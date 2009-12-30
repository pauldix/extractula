require File.dirname(__FILE__) + '/../spec_helper'

describe Extractula::Extractor do
  
  before do
    @url  = "http://www.website.com/"
    @html = ""
  end
  
  it "should not be able to extract anything" do
    Extractula::Extractor.can_extract?(@url, @html).should be_false
  end
  
  describe "extracting" do
    it "should give an empty ExtractedContent object" do
      content = Extractula::Extractor.new.extract(@url, @html)
      content.title.should be_nil
      content.summary.should be_nil
    end
  end
  
  describe "when subclassing" do
    it "should add the subclass as an extractor to the Extractula module" do
      class Thingy < Extractula::Extractor; end
      Extractula.instance_variable_get(:@extractors).should include(Thingy)
    end
  end
end