module Extractula
  class Vimeo < Extractula::Extractor
    include Extractula::OEmbed
    domain              'vimeo'
    media_type          'video'
    oembed_endpoint     'http://www.vimeo.com/api/oembed.json'
    
    def content
      oembed['description']
    end
  end
end