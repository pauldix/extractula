require File.dirname(__FILE__) + '/../spec_helper'

describe "extracted content" do
  it "has a url" do
    Extractula::ExtractedContent.new(:url => "http://pauldix.net").url.should == "http://pauldix.net"
  end

  it "has a title" do
    Extractula::ExtractedContent.new(:title => "whatevs").title.should == "whatevs"
  end

  it "has a summary" do
    Extractula::ExtractedContent.new(:summary => "a summary!").summary.should == "a summary!"
  end

  it "has image_urls" do
    Extractula::ExtractedContent.new(:image_urls => ["first.jpg", "second.tiff"]).image_urls.should == ["first.jpg", "second.tiff"]
  end

  it "has a video_embed" do
    Extractula::ExtractedContent.new(:video_embed => "some embed code").video_embed.should == "some embed code"
  end
end
