require File.dirname(__FILE__) + '/spec_helper'

describe "extractula" do
  it "can add custom extractors" do
    custom_extractor = Class.new(Extractula::Extractor) do
      def self.can_extract? url, html
        true
      end

      def extract
        Extractula::ExtractedContent.new :url => "custom extractor url", :summary => "my custom extractor"
      end
    end

    Extractula.add_extractor custom_extractor
    content = Extractula.extract("http://pauldix.net", "some html")
    content.url.should == "custom extractor url"
    content.summary.should == "my custom extractor"
    Extractula.remove_extractor custom_extractor
  end

  it "skips custom extractors that can't extract the passed url and html" do
    custom_extractor = Class.new(Extractula::Extractor) do
      def self.can_extract? url, html
        false
      end

      def extract
        Extractula::ExtractedContent.new :url => "this url", :summary => "this summary"
      end
    end

    Extractula.add_extractor custom_extractor
    content = Extractula.extract("http://pauldix.net", "some html")
    content.url.should_not == "this url"
    content.summary.should_not == "this summary"
    Extractula.remove_extractor custom_extractor
  end

  it "extracts from a url and document and returns an ExtractedContent object" do
    result = Extractula.extract("http://pauldix.net", "")
    result.should be_a Extractula::ExtractedContent
    result.url.should == "http://pauldix.net"
  end
end