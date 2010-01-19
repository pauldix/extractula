# coding: utf-8

require File.dirname(__FILE__) + '/../../spec_helper'

describe Extractula::YFrog do
  before do
    @url = Domainatrix.parse("http://img70.yfrog.com/i/8pfo.jpg/")
    @html = Nokogiri::HTML::Document.new
  end
  
  it "can extract images from yfrog.com" do
    Extractula::YFrog.can_extract?(@url, @html).should be_true
  end
  
  it "should have media type 'image'" do
    Extractula::YFrog.media_type.should == 'image'
  end
end

describe "extracting from a YFrog page" do
  
  before do
    @extracted_content = Extractula::YFrog.new("http://img70.yfrog.com/i/8pfo.jpg/", read_test_file("yfrog.html")).extract
  end

  it "extracts the title" do
    @extracted_content.title.should == "Yfrog - 8pfo  - Uploaded by cwgabriel"
  end

  it "extracts the content" do
    @extracted_content.content.should == "Done for today I think."
  end

  it "extracts the image url" do
    @extracted_content.image_urls.should include("http://img70.yfrog.com/img70/3152/8pfo.jpg")
  end

end