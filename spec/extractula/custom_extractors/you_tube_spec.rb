require File.dirname(__FILE__) + '/../../spec_helper'

describe Extractula::YouTube do
  before do
    @url = Domainatrix.parse("http://www.youtube.com/watch?v=FzRH3iTQPrk")
    @html = Nokogiri::HTML::Document.new
  end
  
  it "can extract videos from youtube.com" do
    Extractula::YouTube.can_extract?(@url, @html).should be_true
  end
  
  it "should have media type 'video'" do
    Extractula::YouTube.media_type.should == 'video'
  end
end

describe "extracting from a YouTube page" do
  
  before do
    @response = Extractula::OEmbed::Response.new(read_test_file("youtube-oembed.json"))
    Extractula::OEmbed.stub!(:request).and_return(@response)
    @extracted_content = Extractula::YouTube.new("http://www.youtube.com/watch?v=FzRH3iTQPrk", read_test_file("youtube.html")).extract
  end

  it "extracts the title" do
    @extracted_content.title.should == "The Sneezing Baby Panda"
  end

  it "extracts the content" do
    @extracted_content.content.should == "A Baby Panda Sneezing\n\nhttp://www.twitter.com/_jam..."
  end

  it "extracts the main video" do
    @extracted_content.video_embed.should == "<object width=\"425\" height=\"344\"><param name=\"movie\" value=\"http://www.youtube.com/v/FzRH3iTQPrk&fs=1\"></param><param name=\"allowFullScreen\" value=\"true\"></param><param name=\"allowscriptaccess\" value=\"always\"></param><embed src=\"http://www.youtube.com/v/FzRH3iTQPrk&fs=1\" type=\"application/x-shockwave-flash\" width=\"425\" height=\"344\" allowscriptaccess=\"always\" allowfullscreen=\"true\"></embed></object>"
  end

end