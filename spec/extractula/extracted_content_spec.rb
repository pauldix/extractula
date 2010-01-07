# coding: utf-8
require File.dirname(__FILE__) + '/../spec_helper'

describe "extracted content" do
  it "has a url" do
    Extractula::ExtractedContent.new(:url => "http://pauldix.net").url.should == "http://pauldix.net"
  end

  it "has a title" do
    Extractula::ExtractedContent.new(:title => "whatevs").title.should == "whatevs"
  end

  it "has content" do
    Extractula::ExtractedContent.new(:content => "some content").content.should == "some content"
  end

  describe "summary" do
    it "has a summary" do
      Extractula::ExtractedContent.new(:summary => "a summary!").summary.should == "a summary!"
    end

    it "generates the summary from the content" do
      extracted = Extractula::ExtractedContent.new(:content => "<p>I've been quietly working on Typhoeus for the last few months. With the help of <a href=\"http://metaclass.org/\">Wilson Bilkovich</a> and <a href=\"http://github.com/dbalatero\">David Balatero</a> I've finished what I think is a significant improvement to the library. The new interface removes all the magic and opts instead for clarity.</p>\n<p>It's really slick and includes improved stubing support, caching, memoization, and (of course) parallelism. The <a href=\"http://github.com/pauldix/typhoeus/\">Typhoeus readme</a> highlights all of the awesomeness. It should be noted that the old interface of including Typhoeus into classes and defining remote methods has been deprecated. I'll be removing that sometime in the next six months.</p>\n<p>In addition to thanking everyone using the library and everyone contributing, I should also thank my employer kgbweb. If you're a solid Rubyist that likes parsing, crawling, and stuff, or a machine learning guy, or a Solr/Lucene/indexing bad ass, let me know. We need you and we're doing some crazy awesome stuff.</p>")
      extracted.summary.should == "I've been quietly working on Typhoeus for the last few months. With the help of Wilson Bilkovich and David Balatero I've finished what I think is a significant improvement to the library. The new interface removes all the magic and opts instead for clarity."
    end
  end

  describe "image_urls" do
    it "has image_urls" do
      Extractula::ExtractedContent.new(:image_urls => ["first.jpg", "second.tiff"]).image_urls.should == ["first.jpg", "second.tiff"]
    end

    it "generates the image urls from the content" do
      extracted = Extractula::ExtractedContent.new(:content => "<p><a href=\"http://www.businessinsider.com/10-stunning-web-site-prototype-sketches-2009-12/early-ember-1\"><img class=\"float_right\" src=\"http://static.businessinsider.com/~~/f?id=4b3a466f000000000086e662&amp;maxX=311&amp;maxY=233\" border=\"0\" height=\"233\" alt=\"Web site wireframes\" width=\"311\"></a></p>\n<div style=\"float: left; padding: 15px 15px 15px 0;\">\n\n</div>\n<p>When designers start a new Web site, they often sketch out a first idea of the page layout using paper and stencil.&nbsp;</p>\n<p>Designers call this sketch a \"wireframe.\"</p>\n<p>Woorkup.com's Antonio Lupetti <a href=\"http://woorkup.com/2009/12/28/10-beautiful-sketches-for-website-prototypes/\">collected</a> 10 beautiful examples of wireframes.</p>\n<p><a href=\"http://www.businessinsider.com/10-stunning-web-site-prototype-sketches-2009-12/early-ember-1\"><strong>He gave us permission to republish them here &gt;</strong></a></p>")
      extracted.image_urls.should == ["http://static.businessinsider.com/~~/f?id=4b3a466f000000000086e662&maxX=311&maxY=233"]
    end
  end

  describe "video_embed" do
    it "has a video_embed" do
      Extractula::ExtractedContent.new(:video_embed => "some embed code").video_embed.should == "some embed code"
    end

    it "pulls video embed tags from the content" do
      extracted = Extractula::ExtractedContent.new(:content => "<div style=\"float: left; margin-right: 10px; margin-bottom: 4px;\">\n<div class=\"wdt_button\"><iframe scrolling=\"no\" height=\"61\" frameborder=\"0\" width=\"50\" src=\"http://api.tweetmeme.com/widget.js?url=http://mashable.com/2009/12/30/weather-channel-marriage-proposal-touching-with-a-chance-of-viral-status-video/&amp;style=normal&amp;source=mashable&amp;service=bit.ly\"></iframe></div>\n<div class=\"wdt_button\" style=\"height:59px;\">\n<a name=\"fb_share\" type=\"box_count\" share_url=\"http://mashable.com/2009/12/30/weather-channel-marriage-proposal-touching-with-a-chance-of-viral-status-video/\"></a>\n</div>\n</div>\n<p><a href=\"http://mashable.com/wp-content/uploads/2009/12/weather.jpg\"><img src=\"http://mashable.com/wp-content/uploads/2009/12/weather.jpg\" alt=\"\" title=\"weather\" width=\"266\" height=\"184\" class=\"alignright size-full wp-image-174336\"></a>First <a href=\"http://mashable.com/tag/twitter/\">Twitter</a>, then Foursquare, now the Weather Channel? People are broadcasting their wedding proposals all over the place these days. </p>\n<p>That’s right, the other night Weather Channel meteorologist Kim Perez’s beau, police Sgt. Marty Cunningham (best name EVER), asked her to marry him during a routine forecast. Good thing she said yes, otherwise Cunningham’s disposition would have been cloudy with a serious chance of all-out mortification.<br><span id=\"more-174310\"></span></p>\n<p>Social media and viral videos have taken the place of the jumbotron when it comes to marriage proposals, allowing one to sound one’s not-so barbaric yawp over the roofs of the world. In today’s look-at-me society, public proposals are probably the least offensive byproduct. Meaning that even the most hardened of cynics can admit that they’re kind of sweet.</p>\n<p>Check out Cunningham’s proposal below (I personally enjoy that the weather map reads “<em>ring</em>ing in the New Year”), and then dive right into our list of even more social media wooers. What’s next? Entire domains dedicated to popping the question?</p>\n<p></p>\n<center>\n<object width=\"425\" height=\"344\"><param name=\"movie\" value=\"http://www.youtube.com/v/0dHTIGas4CA&amp;color1=0x3a3a3a&amp;color2=0x999999&amp;hl=en_US&amp;feature=player_embedded&amp;fs=1\">\n<param name=\"allowFullScreen\" value=\"true\">\n<param name=\"allowScriptAccess\" value=\"always\">\n<embed wmode=\"opaque\" src=\"http://www.youtube.com/v/0dHTIGas4CA&amp;color1=0x3a3a3a&amp;color2=0x999999&amp;hl=en_US&amp;feature=player_embedded&amp;fs=1\" type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" allowscriptaccess=\"always\" width=\"425\" height=\"344\"></embed></object>\n<p></p>\n</center>\n<hr>\n<h2>More Wedding Bells and Whistles</h2>\n<hr>\n<p><a href=\"http://mashable.com/2009/08/28/mashable-marriage-proposal/\">CONGRATS: Mashable Marriage Proposal Live at #SocialGood [Video]</a></p>\n<p><a href=\"http://mashable.com/2009/12/19/foursquare-proposal/\">Man Proposes Marriage via Foursquare Check-In</a></p>\n<p><a href=\"http://mashable.com/2008/03/21/max-emily-twitter-proposal/\">Did We Just Witness a Twitter Marriage Proposal?</a></p>\n<p><a href=\"http://mashable.com/2009/06/30/twitter-marriage/\">Successful Marriage Proposal on Twitter Today: We #blamedrewscancer</a></p>\n<p><a href=\"http://mashable.com/2009/12/01/groom-facebook-update/\">Just Married: Groom Changes Facebook Relationship Status at the Altar [VIDEO]</a></p>")
      extracted.video_embed.should == "<object width=\"425\" height=\"344\"><param name=\"movie\" value=\"http://www.youtube.com/v/0dHTIGas4CA&amp;color1=0x3a3a3a&amp;color2=0x999999&amp;hl=en_US&amp;feature=player_embedded&amp;fs=1\">\n<param name=\"allowFullScreen\" value=\"true\">\n<param name=\"allowScriptAccess\" value=\"always\">\n<embed wmode=\"opaque\" src=\"http://www.youtube.com/v/0dHTIGas4CA&amp;color1=0x3a3a3a&amp;color2=0x999999&amp;hl=en_US&amp;feature=player_embedded&amp;fs=1\" type=\"application/x-shockwave-flash\" allowfullscreen=\"true\" allowscriptaccess=\"always\" width=\"425\" height=\"344\"></embed></object>"
    end
  end

  describe "some regressions" do
    it "doesn't error with undefined method 'node_name' for nil:NilClass when looking at <br /> elements" do
      extracted = Extractula::Extractor.new("http://viceland.com/caprica/", read_test_file("node-name-error.html")).extract
      extracted.title.should == "Syfy + Motherboard.tv Caprica Screenings Contest"
    end
  end
end
