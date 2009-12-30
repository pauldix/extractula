require File.dirname(__FILE__) + '/../spec_helper'

describe "dom extractor" do
  it "returns an extracted content object with the url set" do
    result = Extractula::DomExtractor.new.extract("http://pauldix.net", "")
    result.should be_a Extractula::ExtractedContent
    result.url.should == "http://pauldix.net"
  end
end

describe "extraction cases" do
  describe "extracting from a typepad blog" do
    before(:all) do
      @extracted_content = Extractula::DomExtractor.new.extract(
        "http://www.pauldix.net/2009/10/typhoeus-the-best-ruby-http-client-just-got-better.html",
        read_test_file("typhoeus-the-best-ruby-http-client-just-got-better.html"))
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
      @extracted_content = Extractula::DomExtractor.new.extract(
        "http://www.techcrunch.com/2009/12/29/totlol-youtube/",
        read_test_file("totlol-youtube.html"))
    end

    it "extracts the title" do
      @extracted_content.title.should == "The Sad Tale Of Totlol And How YouTube’s Changing TOS Made It Hard To Make A Buck"
    end

    it "extracts the content" do
      s = <<-EOS
<p><img class=\"shot2\" src=\"http://cache0.techcrunch.com/wp-content/uploads/2009/12/totlollogo.png\" alt=\"\"></p>\n<p>For developers, the Web is increasingly becoming a rich trove of data which can be plucked and used as the foundation to build new services and applications.  The data on the Web is becoming increasingly accessible through application programming interfaces (APIs), and some of the richest APIs come from the biggest sites on the Web: YouTube, Facebook, Twitter.  But just as these APIs give life to tens of thousands of developers, they can also be limiting.  Ron Ilan, the developer and entrepreneur behind the children&rsquo;s video site <a href=\"http://www.totlol.com/\">Totlol</a>, learned the hard way that if you live by the API, you can also die by the API.</p>\n<p>Totlol is a site filled with <a href=\"http://www.techcrunch.com/2008/11/01/totlol-the-new-saturday-morning-cartoons/\">children&rsquo;s&rsquo; videos from YouTube</a> curated by parents.  Think of it as a safe, white-listed, children&rsquo;s version of YouTube.  It is built entirely on top of YouTube&rsquo;s APIs.  But a change in the terms of service (TOS) of those APIs caused Ron to <a href=\"http://www.techcrunch.com/2009/06/05/totlol-developer-forced-to-shut-down-kids-video-service/\">shut down</a> the free version of his site six months ago and move to a subscription model which never really became a going concern.</p>\n<p>Ron clearly blames YouTube for his woes.  You can read <a href=\"http://www.totlol.com/t/story\">his version of the whole sad tale</a>, which portrays YouTube as conspiring to change its API terms of service in response to Totlol.  Whether or not there was any actual malice on the part of YouTube, or the change was just a coincidence in timing, as someone who was on the YouTube API team told Ilan via email, the episode is a cautionary tale for anyone trying to build a business on another company&rsquo;s APIs.</p>\n<p>The gist of what happened is that Ilan developed Totlol using YouTube&rsquo;s APIs. The service wrapped YouTube videos in Totlol&rsquo;s own player on its site, where people could create collections and do much more.  YouTube noticed the app and even <a href=\"http://google-code-featured.blogspot.com/2008/07/totlol.html\">featured it in its Google Code widget</a> on July 7, 2008, after some delay.  That also happened to be the exact same day that Google changed the <a href=\"http://code.google.com/apis/youtube/creating_monetizable_applications.html\">terms of service for its API</a> to disallow commercial use without &ldquo;YouTube&rsquo;s prior written approval,&rdquo; including for the following:</p>\n<blockquote><p>the sale of advertising, sponsorships, or promotions on any page of the API Client containing YouTube audiovisual content, unless other content not obtained from YouTube appears on the same page and is of sufficient value to be the basis for such sales</p></blockquote>\n<p>That pretty much killed Totlol&rsquo;s revenue model, which was to place ads on the pages where the videos were played.  Just bad luck, right?  Ron asked YouTube for permission to run ads on his site, but he never got a response.  Ron was understandably frustrated buy this turn of events. The site was his livelihood.  In his post, he sums up what he thinks happened this way: </p>\n<blockquote><p>When the YouTube API team saw Totlol they liked it. At about the same time someone else at Google saw it, realized the potential it, and/or similar implementations may have, and initiated a ToS modification. An instruction was given to delay public acknowledgement of Totlol until the modified ToS where published. Later an instruction was given to avoid public acknowledgement at all.</p></blockquote>\n<p>Maybe there was a connection, or maybe this conspiracy existed only in Ron&rsquo;s mind.  It is hard to believe YouTube would modify it in response to a single developer.  In a statement, YouTube responds:</p>\n<blockquote><p>Updates to our API Terms of Service generally take months of preparation and review and are pushed out primarily to better serve our users, partners and developers.  When new Terms of Service are ready, we notify our developers through as many channels as possible, including on our developer blog. </p></blockquote>\n<p>And YouTube did at least try to reach out to him.  In June of this year, he was approached by a director of product management at YouTube who wanted to know what YouTube could do to prevent such failures in the future. In an email, the YouTube director asked Ron:</p>\n<blockquote><p>What types of business models would we need to support in order to make this worth a developer&rsquo;s while?<br>\n. . . Semi-related: what about the YouTube APIs made it challenging to run the site as a standalone?\n</p></blockquote>\n<p>The questions make it clear that YouTube knew there were things it could do to make its APIs more developer-friendly.  The two even met at a Starbucks, but nothing came of the meeting.  </p>\n<p>Ultimately, it was up Ron to build a site that not only attracted users but was also economically viable.  But like many developers, he was at the mercy of YouTube&rsquo;s rules.  Live by the API, die by the API.  Ron is now looking for a regular 9-to-5 job to support his family.</p>\n<p>YouTube has no problem splitting revenues with bigger partners such as Vevo, which show their videos on both their own site and on YouTube.  But maybe YouTube is making a distinction between splitting revenues with content creators and with content aggregators like Totlol.  Is there not enough value in content aggregation when done creatively.  The executives in charge of Google News, at least, would answer in the affirmative.  YouTube is not a kid&rsquo;s site, yet Totlol was able to create a kid&rsquo;s site out of YouTube, with different features and a different look and feel.   </p>\n<p>YouTube wants to control the economics surrounding its videos, whether they are watched on YouTube or on another site.  The last thing it wants is to encourage a bunch of spam sites filled with Youtube videos and AdSense.   That&rsquo;s fair enough.  But Totlol was a legitimate site, even an innovative one.  It was the kind of site YouTube should do everything it can to encourage.  Tales like this one make you wonder how hard it is for developers who want to play by the rules to build businesses on top of those APIs.  Is YouTube helping developers or thwarting them? </p>\n<div class=\"cbw snap_nopreview\">\n<div class=\"cbw_header\">\n<div class=\"cbw_header_text\"><a href=\"http://www.crunchbase.com/\">CrunchBase Information</a></div>\n</div>\n<div class=\"cbw_content\">\n<div class=\"cbw_subheader\"><a href=\"http://www.crunchbase.com/company/totlol\">Totlol</a></div>\n<div class=\"cbw_subcontent\"></div>\n<div class=\"cbw_subheader\"><a href=\"http://www.crunchbase.com/company/youtube\">YouTube</a></div>\n<div class=\"cbw_subcontent\"></div>\n<div class=\"cbw_footer\">Information provided by <a href=\"http://www.crunchbase.com/\">CrunchBase</a>\n</div>\n</div>\n</div>
EOS
      @extracted_content.content.should == s.strip
    end
  end

  describe "extracting from wordpress - mashable" do
    before(:all) do
      @extracted_content = Extractula::DomExtractor.new.extract(
        "http://mashable.com/2009/12/29/ustream-new-years-eve/",
        read_test_file("ustream-new-years-eve.html"))
    end

    it "extracts the title" do
      @extracted_content.title.should == "New Years Eve: Watch Live Celebrations on Ustream"
    end

    it "extracts the content" do
      @extracted_content.content.should == "<div style=\"float: left; margin-right: 10px; margin-bottom: 4px;\">\n<div class=\"wdt_button\"></div>\n<div class=\"wdt_button\" style=\"height: 59px;\">\n<a name=\"fb_share\" type=\"box_count\"></a>\n</div>\n</div>\n<p><a href=\"http://mashable.com/wp-content/uploads/2009/12/happy-new-year.jpg\"><img title=\"happy new year\" class=\"alignright size-full wp-image-173824\" src=\"http://mashable.com/wp-content/uploads/2009/12/happy-new-year.jpg\" height=\"190\" alt=\"\" width=\"260\" style=\"margin: 10px;\"></a>Want to check out New Year&rsquo;s Eve coverage on your mobile phone or computer? You&rsquo;re in luck; <a href=\"http://www.ustream.tv/\" target=\"_blank\">Ustream</a> is ringing in the new year with <a href=\"http://www.ustream.tv/blog/2009/12/29/ringing-in-the-new-year-with-ustream/\" target=\"_blank\">live video streams</a> of New Year&rsquo;s Eve celebrations across the globe.</p>\n<p>This year, you can watch the famous ball drop live in New York&rsquo;s Times Square courtesy of the&nbsp;<a href=\"http://www.ustream.tv/channel/cbs-news\" target=\"_blank\">CBS News channel</a>, catch a live stream of the Funchal Harbor fireworks (<em>Guinness Book of World Records</em> record-holder for the largest fireworks display)&nbsp;off the coast of Portugal on the <a href=\"http://www.ustream.tv/channel/madeira\" target=\"_blank\">Madeira channel</a> starting at 6 p.m. EST or <a href=\"http://www.ustream.tv/channel/junkanoo-2009-parade-live\" target=\"_blank\">watch</a> the <a href=\"http://www.bahamasgo.com/treasures/junkanoo.htm\" target=\"_blank\">Junkanoo Cultural Festival</a> live at the Bahamas in the wee hours on January 1.</p>\n<p><span id=\"more-173822\"></span></p>\n<p>Ustream is also boasting a few more video stream events tied to the new year. R&amp;B artist Trey Songz will be hosting a fan chat in the early evening on his <a href=\"http://www.ustream.tv/treysongz\" target=\"_blank\">channel</a>. Chris Prillio will also be <a href=\"http://www.ustream.tv/chrispirillo\" target=\"_blank\">hosting</a> his annual live event at 10 p.m. EST &mdash;&nbsp;Subservient Chris &mdash;&nbsp;to raise money for the Muscular Dystrophy Association. There&rsquo;s also a star-studded&nbsp;<a href=\"http://www.ustream.tv/channel/omphoy-nye-live-2010-at-o-bar\" target=\"_blank\">red carpet event</a> replete with glitz and glamor at the exclusive Omphoy in Palm Beach that you can watch live.</p>\n<p>The selection of New Years Eve streams available on Ustream is quite impressive. This year you might enjoy ringing in the new year remotely via Ustream more than you normally would if you were to tune in to coverage on your TV set.</p>\n<p><em>image courtesy of <a href=\"http://www.istockphoto.com/mashableoffer.php\" rel=\"nofollow\">iStockphoto</a>, <a href=\"http://www.istockphoto.com/user_view.php?id=2982928\" rel=\"nofollow\">jenjen42</a></em></p>"
    end
  end

  describe "extracting from alleyinsider" do
    before(:all) do
      @extracted_content = Extractula::DomExtractor.new.extract(
        "http://www.businessinsider.com/10-stunning-web-site-prototype-sketches-2009-12",
        read_test_file("10-stunning-web-site-prototype-sketches.html"))
    end

    it "extracts the title" do
      @extracted_content.title.should == "10 Stunning Web Site Prototype Sketches"
    end

    it "extracts the content" do
      @extracted_content.content.should == "<p><a href=\"http://www.businessinsider.com/10-stunning-web-site-prototype-sketches-2009-12/early-ember-1\"><img class=\"float_right\" src=\"http://static.businessinsider.com/~~/f?id=4b3a466f000000000086e662&amp;maxX=311&amp;maxY=233\" border=\"0\" height=\"233\" alt=\"Web site wireframes\" width=\"311\"></a></p>\n<div style=\"float: left; padding: 15px 15px 15px 0;\">\n\n</div>\n<p>When designers start a new Web site, they often sketch out a first idea of the page layout using paper and stencil.&nbsp;</p>\n<p>Designers call this sketch a \"wireframe.\"</p>\n<p>Woorkup.com's Antonio Lupetti <a href=\"http://woorkup.com/2009/12/28/10-beautiful-sketches-for-website-prototypes/\">collected</a> 10 beautiful examples of wireframes.</p>\n<p><a href=\"http://www.businessinsider.com/10-stunning-web-site-prototype-sketches-2009-12/early-ember-1\"><strong>He gave us permission to republish them here &gt;</strong></a></p>"
    end
  end
end
