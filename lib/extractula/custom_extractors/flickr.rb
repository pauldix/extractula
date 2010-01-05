module Extractula
  class Flickr < Extractula::Extractor
    include Extractula::OEmbed
    domain              'flickr'
    content_path        'div.photoDescription'
    oembed_endpoint     'http://www.flickr.com/services/oembed/'
  end
end