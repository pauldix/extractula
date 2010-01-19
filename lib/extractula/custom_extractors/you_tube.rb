module Extractula
  class YouTube < Extractula::Extractor
    include Extractula::OEmbed
    domain              'youtube'
    media_type          'video'
    content_path        '.description'
    oembed_endpoint     'http://www.youtube.com/oembed'
  end
end