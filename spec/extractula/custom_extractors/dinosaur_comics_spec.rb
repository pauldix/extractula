require File.dirname(__FILE__) + '/../../spec_helper'

describe Extractula::DinosaurComics do
  
  it "can extract comics from qwantz.com" do
    Extractula::DinosaurComics.can_extract?("http://www.qwantz.com/index.php", "").should be_true
  end
  
end

describe "extracting from a Dinosaur Comics page" do
  
  before do
    @extracted_content = Extractula.extract "http://www.qwantz.com/index.php", read_test_file("dinosaur-comics.html")
  end

  it "extracts the title" do
    @extracted_content.title.should == "Dinosaur Comics - December 30th, 2009 - awesome fun times!"
  end

  it "extracts the summary" do
    @extracted_content.summary.should == "tell this to a doctor and they will have no choice but to make you a doctor too, this is a TRUE FACT"
  end

  it "extracts the main comic" do
    @extracted_content.image_urls.should include "http://www.qwantz.com/comics/comic2-503.png"
  end

end

