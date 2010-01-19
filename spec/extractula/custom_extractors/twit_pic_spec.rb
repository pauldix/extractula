# coding: utf-8

require File.dirname(__FILE__) + '/../../spec_helper'

describe Extractula::TwitPic do
  before do
    @url = Domainatrix.parse("http://twitpic.com/ytw1u")
    @html = Nokogiri::HTML::Document.new
  end
  
  it "can extract images from twitpic.com" do
    Extractula::TwitPic.can_extract?(@url, @html).should be_true
  end
  
  it "should have media type 'image'" do
    Extractula::TwitPic.media_type.should == 'image'
  end
end

describe "extracting from a TwitPic page" do
  
  before do
    @extracted_content = Extractula::TwitPic.new("http://twitpic.com/ytw1u", read_test_file("twitpic.html")).extract
  end

  it "extracts the title" do
    @extracted_content.title.should == "@AMY_CLUB si te dejo Jack ? Lol on Twitpic"
  end

  it "extracts the content" do
    @extracted_content.content.should == "@AMY_CLUB si te dejo Jack ? Lol"
  end

  it "extracts the image url" do
    @extracted_content.image_urls.should include("http://web4.twitpic.com/img/58501506-137b4b4c8b5b0244f4b0d9d607e14941.4b56110f-full.jpg")
  end

end