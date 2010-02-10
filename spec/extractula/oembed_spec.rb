require File.dirname(__FILE__) + '/../spec_helper'

describe Extractula::OEmbed do
  
  describe "setting a global max height" do
    before do
      class Thing; include Extractula::OEmbed; end
      Extractula::OEmbed.max_height 500
    end
    
    it "should be the default height for all OEmbeddable classes" do
      Thing.oembed_max_height.should == 500
    end
    
    it "should not override a specified height" do
      Thing.oembed_max_height 300
      Thing.oembed_max_height.should == 300      
    end
  end

  describe "setting a global max width" do
    before do
      class Thing; include Extractula::OEmbed; end
      Extractula::OEmbed.max_width 500
    end
    
    it "should be the default width for all OEmbeddable classes" do
      Thing.oembed_max_width.should == 500
    end
    
    it "should not override a specified width" do
      Thing.oembed_max_width 300
      Thing.oembed_max_width.should == 300      
    end
  end
  
end