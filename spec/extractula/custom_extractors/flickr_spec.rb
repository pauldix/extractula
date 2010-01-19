# coding: utf-8

require File.dirname(__FILE__) + '/../../spec_helper'

describe Extractula::Flickr do
  before do
    @url = Domainatrix.parse("http://www.flickr.com/photos/kotobuki711/1789570897/")
    @html = Nokogiri::HTML::Document.new
  end
  
  it "can extract videos from flickr.com" do
    Extractula::Flickr.can_extract?(@url, @html).should be_true
  end
  
  it "should have media type 'image'" do
    Extractula::Flickr.media_type.should == 'image'
  end
end

describe "extracting from a YouTube page" do
  
  before do
    @response = Extractula::OEmbed::Response.new(read_test_file("flickr-oembed.json"))
    Extractula::OEmbed.stub!(:request).and_return(@response)
    @extracted_content = Extractula::Flickr.new("http://www.flickr.com/photos/kotobuki711/1789570897/", read_test_file("flickr.html")).extract
  end

  it "extracts the title" do
    @extracted_content.title.should == "Greyhound Fisheye"
  end

  it "extracts the content" do
    @extracted_content.content.should == "A Greyhound named Latte at Meadow Woods Dog Park in Orlando, FL.  Published in All Animals Magazine."
  end

  it "extracts the image url" do
    @extracted_content.image_urls.should include("http:\/\/farm3.static.flickr.com\/2127\/1789570897_6db70a9dbe.jpg")
  end

end