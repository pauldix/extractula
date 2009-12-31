require File.dirname(__FILE__) + '/../spec_helper'

describe Extractula::Extractor do
  
  before do
    @url  = Domainatrix.parse("http://www.website.com/")
    @html = Nokogiri::HTML::Document.new
  end
  
  it "should not be able to extract anything" do
    Extractula::Extractor.can_extract?(@url, @html).should be_false
  end
  
  describe "extracting" do
    it "should give an empty ExtractedContent object" do
      content = Extractula::Extractor.new(@url, @html).extract
      content.title.should be_nil
      content.summary.should be_empty
      content.image_urls.should be_empty
      content.video_embed.should be_nil
    end
  end
  
  describe "when subclassing" do
    before do
      class Thingy < Extractula::Extractor; end
    end

    it "should add the subclass as an extractor to the Extractula module" do
      Extractula.instance_variable_get(:@extractors).should include(Thingy)
    end
    
    describe "setting the domain" do
      before do
        Thingy.domain 'website'
      end
      
      it "should be able to extract urls from that domain" do
        Thingy.can_extract?(@url, @html).should be_true
      end
    end    
  end
end