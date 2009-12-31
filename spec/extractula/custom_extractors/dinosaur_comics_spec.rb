require File.dirname(__FILE__) + '/../../spec_helper'

describe Extractula::DinosaurComics do
  before do
    @url = Domainatrix.parse("http://www.qwantz.com/index.php")
    @html = Nokogiri::HTML::Document.new
  end
  
  it "can extract comics from qwantz.com" do
    Extractula::DinosaurComics.can_extract?(@url, @html).should be_true
  end
  
end

describe "extracting from a Dinosaur Comics page" do
  
  before do
    @extracted_content = Extractula::DinosaurComics.new("http://www.qwantz.com/index.php", read_test_file("dinosaur-comics.html")).extract
  end

  it "extracts the title" do
    @extracted_content.title.should == "Dinosaur Comics - December 30th, 2009 - awesome fun times!"
  end

  it "extracts the content" do
    @extracted_content.content.should == "tell this to a doctor and they will have no choice but to make you a doctor too, this is a TRUE FACT"
  end

  it "extracts the main comic" do
    @extracted_content.image_urls.should include "http://www.qwantz.com/comics/comic2-503.png"
  end

end

