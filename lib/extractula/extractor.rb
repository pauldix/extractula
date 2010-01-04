# Abstract (more or less) extractor class from which custom extractor
# classes should descend. Subclasses of Extractula::Extractor will be
# automatically added to the Extracula module.

module Extractula
  class Extractor
    
    DEFAULTS = {
      :title        => 'title',
      :summary      => Proc.new { excerpt(content) },
      :image_urls   => 'img',
      :video_embed  => 'object',
      :content      => Proc.new {
        def calculate_children_text_size(parent, node_type)
          text_size = 0
          parent.children.each do |child|
            if child.node_name == node_type
              child.children.each {|c| text_size += c.text.strip.size if c.node_name == "text"}
            end
          end

          text_size
        end

        candidate_nodes = html.search("//div|//p|//br").collect do |node|
          parent = node.parent
          if node.node_name == 'div'
            text_size = calculate_children_text_size(parent, "div")

            if text_size > 0
              {:text_size => text_size, :parent => parent}
            else
              nil
            end
          elsif node.node_name == "p"
            text_size = calculate_children_text_size(parent, "p")

            if text_size > 0
              {:text_size => text_size, :parent => parent}
            else
              nil
            end
          elsif node.node_name == "br"
            if node.previous.node_name == "text" && node.next.node_name == "text"
              text_size = 0
              parent.children.each do |child|
                text_size += child.text.strip.size if child.node_name == "text"
              end

              if text_size > 0
                {:text_size => text_size, :parent => parent}
              else
                nil
              end
            else
              nil
            end
          else
            nil
          end
        end.compact.uniq

        fragment = candidate_nodes.detect {|n| n[:text_size] > 140}[:parent].inner_html.strip rescue ""
      }
    }
    
    def self.inherited subclass
      Extractula.add_extractor subclass
    end
  
    def self.domain domain
      @extractable_domain = domain
    end
    
    def self.can_extract? url, html
      @extractable_domain ? @extractable_domain == url.domain : false
    end
    
    %w{ title content summary image_urls video_embed }.each do |field|
      class_eval <<-EOS
        def self.#{field}_path(path = nil, attrib = nil)
          if path
            @#{field}_path = path
            @#{field}_attr = attrib || :text
          end
          @#{field}_path
        end
        
        def self.#{field}_attr(attrib = nil)
          @#{field}_attr = attrib if attrib
          @#{field}_attr
        end
        
        def #{field}_path
          self.class.#{field}_path
        end
        
        def #{field}_attr
          self.class.#{field}_attr
        end
      EOS
    end
    
    def self.use_defaults *fields
      fields.each do |field|
        default = DEFAULTS[field]
        case default
        when String, Array
          __send__ :"#{field}_path", *default
        when Proc
          define_method field, &default
        end
      end
    end
    
    attr_reader :url, :html, :content
    
    def initialize url, html
      @url  = url.is_a?(Domainatrix::Url) ? url : Domainatrix.parse(url)
      @html = html.is_a?(Nokogiri::HTML::Document) ? html : Nokogiri::HTML(html)
    end
    
    def extract
      @content = Extractula::ExtractedContent.new({
        :url          => url.url,
        :title        => title,
        :content      => content,
        :summary      => summary,
        :image_urls   => image_urls,
        :video_embed  => video_embed
      })
    end

    def title
      @title ||= content_at(title_path, title_attr)
    end

    def content
      @content ||= content_at(content_path, content_attr)
    end

    def summary
      @summary ||= summary_path ? content_at(summary_path, summary_attr) : excerpt(content)
    end

    def image_urls
      @image_urls ||= html.search(image_urls_path).collect { |img| img['src'].strip } rescue []
    end
    
    def video_embed
      @video_embed ||= html.search(video_embed_path).collect { |embed| embed.to_html }.first rescue nil 
    end
    
    private
    
    def content_at(path, attrib)
      begin
        node = html.at(path)
        attrib == :text ? node.text.strip : node[attrib].strip
      rescue
        nil
      end
    end
    
    def excerpt(text)
      if text
        content_fragment  = text.slice(0, 350)
        sentence_break    = content_fragment.rindex(/\?|\.|\!|\;/)
        sentence_break ? content_fragment.slice(0, sentence_break + 1) : content_fragment
      end
    end
    
  end
end