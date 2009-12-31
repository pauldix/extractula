# Abstract (more or less) extractor class from which custom extractor
# classes should descend. Subclasses of Extractula::Extractor will be
# automatically added to the Extracula module.

module Extractula
  class Extractor
    
    def self.inherited subclass
      Extractula.add_extractor subclass
    end
  
    def self.domain domain
      @extractable_domain = domain
    end
    
    def self.can_extract? url, html
      @extractable_domain ? @extractable_domain == url.domain : false
    end
    
    %w{ title_path content_path summary_path image_urls_path video_embed_path }.each do |path|
      class_eval <<-EOS
        def self.#{path}(path = nil)
          @#{path} = path if path
          @#{path}
        end
        
        def #{path}
          self.class.#{path}
        end
      EOS
    end
    
    attr_reader :original_url, :url, :html, :content
    
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

    def title_path
      self.class.title_path
    end

    def title
      html.search(title_path).first.text.strip rescue nil
    end

    def content_path
      self.class.content_path
    end
    
    def content
      html.search(content_path).first.text.strip rescue nil
    end

    def summary_path
      self.class.summary_path
    end

    def summary
      if summary_path
        html.search(summary_path).first.text.strip rescue nil
      else
        content_fragment  = content.slice(0, 350)
        sentence_break    = content_fragment.rindex(/\?|\.|\!|\;/)
        sentence_break ? content_fragment.slice(0, sentence_break + 1) : content_fragment
      end
    end

    def image_urls_path
      self.class.image_urls_path
    end
    
    def image_urls
      html.search(image_urls_path).collect { |img| img['src'].strip } rescue []
    end
    
    def video_embed_path
      self.class.video_embed_path
    end
    
    def video_embed
      html.search(video_embed_path).collect { |embed| embed.to_html }.first rescue nil 
    end
    
  end
end