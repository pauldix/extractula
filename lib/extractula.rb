$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

module Extractula; end

require 'nokogiri'
require 'domainatrix'

module Extractula
  @extractors = []

  def self.add_extractor(extractor_class)
    @extractors << extractor_class
  end

  def self.remove_extractor(extractor_class)
    @extractors.delete extractor_class
  end

  def self.extract(url, html)
    parsed_url = Domainatrix.parse(url)
    parsed_html = Nokogiri::HTML(html)
    extractor = @extractors.detect {|e| e.can_extract? parsed_url, parsed_html} || DomExtractor
    extractor.new(parsed_url, parsed_html).extract
  end
end

require 'extractula/extracted_content'
require 'extractula/extractor'
require 'extractula/dom_extractor'