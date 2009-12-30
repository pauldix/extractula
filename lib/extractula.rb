$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

module Extractula; end

require 'nokogiri'
require 'domainatrix'
require 'loofah'
require 'extractula/extracted_content'
require 'extractula/extractor'
require 'extractula/dom_extractor'

module Extractula
  @extractors = []

  def self.add_extractor(extractor_class)
    @extractors << extractor_class
  end

  def self.remove_extractor(extractor_class)
    @extractors.delete extractor_class
  end

  def self.extract(url, html)
    extractor = @extractors.detect {|e| e.can_extract? url, html} || DomExtractor
    extractor.new.extract(url, html)
  end
end
