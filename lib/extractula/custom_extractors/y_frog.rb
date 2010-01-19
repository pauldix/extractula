module Extractula
  class YFrog < Extractula::Extractor
    domain          'yfrog'
    media_type      'image'
    content_path    '.twittertweet div div > div'
    image_urls_path '#main_image'
  end
end