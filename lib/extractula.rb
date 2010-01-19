$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

module Extractula; end

require 'nokogiri'
require 'domainatrix'
require 'extractula/extracted_content'
require 'extractula/extractor'

module Extractula
  VERSION = "0.0.3"

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
    extractor = @extractors.detect {|e| e.can_extract? parsed_url, parsed_html} || Extractor
    extractor.new(parsed_url, parsed_html).extract
  end

  def self.custom_extractor(config = {})
    klass = Class.new(Extractula::Extractor)
    klass.include(Extractula::OEmbed) if config.delete(:oembed)
    config.each { |option, args| klass.__send__(option, *args) }
    klass
  end
end