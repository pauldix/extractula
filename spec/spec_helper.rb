require "rubygems"
require "spec"

# gem install redgreen for colored test output
begin require "redgreen" unless ENV['TM_CURRENT_LINE']; rescue LoadError; end

path = File.expand_path(File.dirname(__FILE__) + "/../lib/")
$LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)

require "lib/extractula"
require "lib/extractula/custom_extractors"

def read_test_file(file_name)
  File.read("#{File.dirname(__FILE__)}/test-files/#{file_name}")
end
