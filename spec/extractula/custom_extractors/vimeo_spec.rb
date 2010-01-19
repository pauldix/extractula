# encoding: utf-8

require File.dirname(__FILE__) + '/../../spec_helper'

describe Extractula::Vimeo do
  before do
    @url = Domainatrix.parse("http://vimeo.com/8833777")
    @html = Nokogiri::HTML::Document.new
  end
  
  it "can extract videos from vimeo.com" do
    Extractula::Vimeo.can_extract?(@url, @html).should be_true
  end
  
  it "should have media type 'video'" do
    Extractula::Vimeo.media_type.should == 'video'
  end
end

describe "extracting from a Vimeo page" do
  
  before do
    @response = Extractula::OEmbed::Response.new(read_test_file("vimeo.json"))
    Extractula::OEmbed.stub!(:request).and_return(@response)
    @extracted_content = Extractula::Vimeo.new("http://vimeo.com/8833777", read_test_file("vimeo.html")).extract
  end

  it "extracts the title" do
    @extracted_content.title.should == "Cracker Bag"
  end

  it "extracts the content" do
    @extracted_content.content.should == "Eddie spends her pocket money obsessively hoarding fireworks and carefully planning for cracker night. When it finally it arrives, Eddie and her family head to the local football oval. In the frosty air Eddie lights the fuse of her first cracker and experiences a pivotal moment, one of the seemingly small experiences of childhood, that affects us for the rest of our lives. \n\nSet in the 1980s, Cracker Bag is a gentle suburban observation which subtly reflects a disenchanting prelude to the coming of age. \n\nWinner of the Palme D'Or - Short Film Cannes Film Festival 2003\n\nwww.GlendynIvin.com\nwww.Exitfilms.com"
  end

  it "extracts the main video" do
    @extracted_content.video_embed.should == "<object width=\"640\" height=\"360\"><param name=\"allowfullscreen\" value=\"true\" \/><param name=\"allowscriptaccess\" value=\"always\" \/><param name=\"movie\" value=\"http:\/\/vimeo.com\/moogaloop.swf?clip_id=8833777&server=vimeo.com&show_title=1&show_byline=1&show_portrait=1&color=00ADEF&fullscreen=1\" \/><embed src=\"http:\/\/vimeo.com\/moogaloop.swf?clip_id=8833777&server=vimeo.com&show_title=1&show_byline=1&show_portrait=1&color=00ADEF&fullscreen=1\" type=\"application\/x-shockwave-flash\" allowfullscreen=\"true\" allowscriptaccess=\"always\" width=\"640\" height=\"360\"><\/embed><\/object>"
  end

end