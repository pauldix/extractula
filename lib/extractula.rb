$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

module Extractula; end

require 'nokogiri'
require 'loofah'
require 'domainatrix'
require 'extractula/extracted_content'
require 'extractula/extractor'

module Extractula
  VERSION = "0.0.8"

  @extractors = []

  class << self
    
    attr_reader :last_extractor
    
    def add_extractor(extractor_class)
      @extractors << extractor_class
    end

    def remove_extractor(extractor_class)
      @extractors.delete extractor_class
    end

    def extract(url, html)
      parsed_url, parsed_html = Domainatrix.parse(url), Nokogiri::HTML(html)
      extractor = select_extractor parsed_url, parsed_html
      extractor.new(parsed_url, parsed_html).extract
    end

    def select_extractor url, html
      @last_extractor = @extractors.detect {|e| e.can_extract? url, html} || Extractor
    end

    def custom_extractor(config = {})
      klass = Class.new(Extractula::Extractor)
      klass.include(Extractula::OEmbed) if config.delete(:oembed)
      config.each { |option, args| klass.__send__(option, *args) }
      klass
    end
  end
end