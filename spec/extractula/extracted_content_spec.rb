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

  it "has a video_embed" do
    Extractula::ExtractedContent.new(:video_embed => "some embed code").video_embed.should == "some embed code"
  end
end
