# This is mostly a proof-of-concept.

module Extractula
  class DinosaurComics < Extractula::Extractor
    
    domain          'qwantz'
    title_path      'title'
    content_path    'img.comic', 'title'
    image_urls_path 'img.comic'    
  end
end