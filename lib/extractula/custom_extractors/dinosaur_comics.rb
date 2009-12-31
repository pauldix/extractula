# This is mostly a proof-of-concept.

module Extractula
  class DinosaurComics < Extractula::Extractor
    
    domain 'qwantz'
    title_path 'title'
    image_urls_path 'img.comic'
    
    def content
      html.search('img.comic').first['title'].strip rescue nil
    end
  end
end