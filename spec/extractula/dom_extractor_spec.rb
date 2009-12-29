require File.dirname(__FILE__) + '/../spec_helper'

describe "dom extractor" do
  it "returns an extracted content object with the url set" do
    result = Extractula::DomExtractor.new.extract("http://pauldix.net", "")
    result.should be_a Extractula::ExtractedContent
    result.url.should == "http://pauldix.net"
  end
end
