# This is mostly a proof-of-concept.

module Extractula
  class DinosaurComics < Extractula::Extractor
    
    def self.can_extract? url, html
      Domainatrix.parse(url).domain == 'qwantz'
    end
    
    def extract url, html
      @doc = Nokogiri::HTML(html)
      Extractula::ExtractedContent.new({
        :url        => url,
        :title      => title,
        :summary    => summary,
        :image_urls => main_comic
      })
    end
    
    def title
      @doc.search('title').first.text.strip rescue nil
    end
    
    def summary
      @doc.search('img.comic').first['title'].strip rescue nil
    end
        
    def main_comic
      Array(@doc.search('img.comic').first['src']) rescue []
    end
  end
end