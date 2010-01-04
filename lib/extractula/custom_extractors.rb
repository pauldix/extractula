require File.dirname(__FILE__) + '/oembed'

Dir.glob(File.dirname(__FILE__) + '/custom_extractors/*.rb').each do |lib|
  require File.expand_path(lib).chomp('.rb')
end