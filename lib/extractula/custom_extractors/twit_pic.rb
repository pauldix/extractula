module Extractula
  class TwitPic < Extractula::Extractor
    domain          'twitpic'
    media_type      'image'
    content_path    '#view-photo-caption'
    image_urls_path '#photo-display'
  end
end