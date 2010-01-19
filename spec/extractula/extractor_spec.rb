# coding: utf-8

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
  
  describe "media type" do
    before do
      class Thingy < Extractula::Extractor; end
      @thingy = Thingy.new @url, @html
    end
    
    it "should default to 'text'" do
      @thingy.media_type.should == 'text'
    end
    
    describe "when set" do
      before do
        Thingy.media_type 'video'
      end
      
      it "should be the given media type" do
        @thingy.media_type.should == 'video'
      end
    end
  end
end

describe "dom extraction" do
  it "returns an extracted content object with the url set" do
    result = Extractula::Extractor.new("http://pauldix.net", "").extract
    result.should be_a Extractula::ExtractedContent
    result.url.should == "http://pauldix.net"
  end
end

describe "extraction cases" do
  describe "extracting from a typepad blog" do
    before(:all) do
      @extracted_content = Extractula::Extractor.new(
        "http://www.pauldix.net/2009/10/typhoeus-the-best-ruby-http-client-just-got-better.html",
        read_test_file("typhoeus-the-best-ruby-http-client-just-got-better.html")).extract
    end

    it "extracts the title" do
      @extracted_content.title.should == "Paul Dix Explains Nothing: Typhoeus, the best Ruby HTTP client just got better"
    end

    it "extracts the content" do
      @extracted_content.content.should == "<p>I've been quietly working on Typhoeus for the last few months. With the help of <a href=\"http://metaclass.org/\">Wilson Bilkovich</a> and <a href=\"http://github.com/dbalatero\">David Balatero</a> I've finished what I think is a significant improvement to the library. The new interface removes all the magic and opts instead for clarity.</p>\n<p>It's really slick and includes improved stubing support, caching, memoization, and (of course) parallelism. The <a href=\"http://github.com/pauldix/typhoeus/\">Typhoeus readme</a> highlights all of the awesomeness. It should be noted that the old interface of including Typhoeus into classes and defining remote methods has been deprecated. I'll be removing that sometime in the next six months.</p>\n<p>In addition to thanking everyone using the library and everyone contributing, I should also thank my employer kgbweb. If you're a solid Rubyist that likes parsing, crawling, and stuff, or a machine learning guy, or a Solr/Lucene/indexing bad ass, let me know. We need you and we're doing some crazy awesome stuff.</p>"
    end
  end

  describe "extracting from wordpress - techcrunch" do
    before(:all) do
      @extracted_content = Extractula::Extractor.new(
        "http://www.techcrunch.com/2009/12/29/totlol-youtube/",
        read_test_file("totlol-youtube.html")).extract
    end

    it "extracts the title" do
      @extracted_content.title.should == "The Sad Tale Of Totlol And How YouTube’s Changing TOS Made It Hard To Make A Buck"
    end

    it "extracts the content" do
      @extracted_content.content.should == Nokogiri::HTML(read_test_file("totlol-youtube.html")).css("div.entry").first.inner_html.strip
    end
  end

  describe "extracting from wordpress - mashable" do
    before(:all) do
      @extracted_content = Extractula::Extractor.new(
        "http://mashable.com/2009/12/29/ustream-new-years-eve/",
        read_test_file("ustream-new-years-eve.html")).extract
    end

    it "extracts the title" do
      @extracted_content.title.should == "New Years Eve: Watch Live Celebrations on Ustream"
    end

    it "extracts the content" do
      @extracted_content.content.should == Nokogiri::HTML(read_test_file("ustream-new-years-eve.html")).css("div.text-content").first.inner_html.strip
    end

    it "extracts content with a video embed" do
      extracted = Extractula::Extractor.new(
        "http://mashable.com/2009/12/30/weather-channel-marriage-proposal-touching-with-a-chance-of-viral-status-video/",
        read_test_file("weather-channel-marriage-proposal-touching-with-a-chance-of-viral-status-video.html")).extract
      extracted.content.should == "<div style=\"float: left; margin-right: 10px; margin-bottom: 4px;\">\n<div class=\"wdt_button\"><iframe scrolling=\"no\" height=\"61\" frameborder=\"0\" width=\"50\" src=\"http://api.tweetmeme.com/widget.js?url=http://mashable.com/2009/12/30/weather-channel-marriage-proposal-touching-with-a-chance-of-viral-status-video/&amp;style=normal&amp;source=mashable&amp;service=bit.ly\"></iframe></div>\n<div class=\"wdt_button\" style=\"height:59px;\">\n<a name=\"fb_share\" type=\"box_count\" share_url=\"http://mashable.com/2009/12/30/weather-channel-marriage-proposal-touching-with-a-chance-of-viral-status-video/\"></a>\n</div>\n</div>\n<p><a href=\"http://mashable.com/wp-content/uploads/2009/12/weather.jpg\"><img src=\"http://mashable.com/wp-content/uploads/2009/12/weather.jpg\" alt=\"\" title=\"weather\" width=\"266\" height=\"184\" class=\"alignright size-full wp-image-174336\"></a>First <a href=\"http://mashable.com/tag/twitter/\">Twitter</a>, then Foursquare, now the Weather Channel? People are broadcasting their wedding proposals all over the place these days. </p>\n<p>That’s right, the other night Weather Channel meteorologist Kim Perez’s beau, police Sgt. Marty Cunningham (best name EVER), asked her to marry him during a routine forecast. Good thing she said yes, otherwise Cunningham’s disposition would have been cloudy with a serious chance of all-out mortification.<br><span id=\"more-174310\"></span></p>\n<p>Social media and viral videos have taken the place of the jumbotron when it comes to marriage proposals, allowing one to sound one’s not-so barbaric yawp over the roofs of the world. In today’s look-at-me society, public proposals are probably the least offensive byproduct. Meaning that even the most hardened of cynics can admit that they’re kind of sweet.</p>\n<p>Check out Cunningham’s proposal below (I personally enjoy that the weather map reads “<em>ring</em>ing in the New Year”), and then dive right into our list of even more social media wooers. What’s next? Entire domains dedicated to popping the question?</p>\n<p></p>\n<center>\n<object width=\"425\" height=\"344\"><param name=\"movie\" value=\"http://www.youtube.com/v/0dHTIGas4CA&amp;color1=0x3a3a3a&amp;color2=0x999999&amp;hl=en_US&amp;feature=player_embedded&amp;fs=1\">\n<param name=\"allowFullScreen\" value=\"true\">\n<param name=\"allowScriptAccess\" value=\"always\">\n<embed wmode=\"opaque\" src=\"http://www.youtube.com/v/0dHTIGas4CA&amp;color1=0x3a3a3a&amp;color2=0x999999&amp;hl=en_US&amp;feature=player_embedded&amp;fs=1\" type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" allowscriptaccess=\"always\" width=\"425\" height=\"344\"></embed></object>\n<p></p>\n</center>\n<hr>\n<h2>More Wedding Bells and Whistles</h2>\n<hr>\n<p><a href=\"http://mashable.com/2009/08/28/mashable-marriage-proposal/\">CONGRATS: Mashable Marriage Proposal Live at #SocialGood [Video]</a></p>\n<p><a href=\"http://mashable.com/2009/12/19/foursquare-proposal/\">Man Proposes Marriage via Foursquare Check-In</a></p>\n<p><a href=\"http://mashable.com/2008/03/21/max-emily-twitter-proposal/\">Did We Just Witness a Twitter Marriage Proposal?</a></p>\n<p><a href=\"http://mashable.com/2009/06/30/twitter-marriage/\">Successful Marriage Proposal on Twitter Today: We #blamedrewscancer</a></p>\n<p><a href=\"http://mashable.com/2009/12/01/groom-facebook-update/\">Just Married: Groom Changes Facebook Relationship Status at the Altar [VIDEO]</a></p>"
    end
  end

  describe "extracting from alleyinsider" do
    before(:all) do
      @extracted_content = Extractula::Extractor.new(
        "http://www.businessinsider.com/10-stunning-web-site-prototype-sketches-2009-12",
        read_test_file("10-stunning-web-site-prototype-sketches.html")).extract
    end

    it "extracts the title" do
      @extracted_content.title.should == "10 Stunning Web Site Prototype Sketches"
    end

    it "extracts the content" do
      @extracted_content.content.should == Nokogiri::HTML(read_test_file("10-stunning-web-site-prototype-sketches.html")).css("div.KonaBody").first.inner_html.strip
    end
  end

  describe "extracting from nytimes" do
    before(:all) do
      @front_page = Extractula::Extractor.new(
        "http://www.nytimes.com/",
        read_test_file("nytimes.html")).extract
      @story_page = Extractula::Extractor.new(
        "http://www.nytimes.com/2009/12/31/world/asia/31history.html?_r=1&hp",
        read_test_file("nytimes_story.html")).extract
    end

    it "extracts the title" do
      @front_page.title.should == "The New York Times - Breaking News, World News & Multimedia"
    end

    it "extracts the content" do
      @front_page.content.should == Nokogiri::HTML(read_test_file("nytimes.html")).css("div.story").first.inner_html.strip
    end

    it "extracts a story title" do
      @story_page.title.should == "Army Historians Document Early Missteps in Afghanistan - NYTimes.com"
    end

    it "extracts the story content" do
      @story_page.content.should == Nokogiri::HTML(read_test_file("nytimes_story.html")).css("nyt_text").first.inner_html.strip
    end
  end
end
