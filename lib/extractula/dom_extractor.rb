# a basic dom based extractor. it's a generic catch all
class Extractula::DomExtractor
  def extract url, html
    @doc = Nokogiri::HTML(html)
    extracted = Extractula::ExtractedContent.new :url => url, :title => title, :content => content
  end

  def title
    @title ||= @doc.search("//title").first.text.strip rescue nil
  end

  def content
    candidate_nodes = @doc.search("//div|//p|//br").collect do |node|
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

    fragment = candidate_nodes.detect {|n| n[:text_size] > 200}[:parent].inner_html.strip rescue ""
#    Loofah.fragment(fragment).scrub!(:prune).to_s
  end

  def summary
  end

  def calculate_children_text_size(parent, node_type)
    text_size = 0
    parent.children.each do |child|
      if child.node_name == node_type
        child.children.each {|c| text_size += c.text.strip.size if c.node_name == "text"}
      end
    end

    text_size
  end
end
