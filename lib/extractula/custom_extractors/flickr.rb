module Extractula
  class Flickr < Extractula::Extractor
    include Extractula::OEmbed
    domain              'flickr'
    media_type          'image'
    content_path        'meta[name=description]', 'content'
    oembed_endpoint     'http://www.flickr.com/services/oembed/'
  end
end