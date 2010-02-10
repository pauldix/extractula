# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{extractula}
  s.version = "0.0.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Paul Dix", "Sander Hartlage"]
  s.date = %q{2009-12-18}
  s.email = %q{paul@pauldix.net}
  s.files = [
    "lib/extractula.rb",
    "lib/extractula/custom_extractors.rb",
    "lib/extractula/extracted_content.rb",
    "lib/extractula/extractor.rb",
    "lib/extractula/oembed.rb",
    "lib/extractula/custom_extractors/dinosaur_comics.rb",
    "lib/extractula/custom_extractors/flickr.rb",
    "lib/extractula/custom_extractors/twit_pic.rb",
    "lib/extractula/custom_extractors/vimeo.rb",
    "lib/extractula/custom_extractors/y_frog.rb",
    "lib/extractula/custom_extractors/you_tube.rb",
    "README.textile",
    "spec/spec.opts",
    "spec/spec_helper.rb",
    "spec/extractula_spec.rb",
    "spec/extractula/extracted_content_spec.rb",
    "spec/test-files/10-stunning-web-site-prototype-sketches.html",
    "spec/test-files/totlol-youtube.html",
    "spec/test-files/typhoeus-the-best-ruby-http-client-just-got-better.html",
    "spec/test-files/ustream-new-years-eve.html",
    "spec/test-files/weather-channel-marriage-proposal-touching-with-a-chance-of-viral-status-video.html",
    "spec/test-files/nytimes.html",
    "spec/test-files/nytimes_story.html",
    "spec/test-files/script_tag_remove_case.html"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/pauldix/extractula}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Extracts content like title, summary, and images from web pages like Dracula extracts blood: with care and finesse.}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>, ["> 0.0.0"])
      s.add_runtime_dependency(%q<loofah>, [">= 0.4.2"])
    else
      s.add_dependency(%q<nokogiri>, ["> 0.0.0"])
      s.add_dependency(%q<loofah>, [">= 0.4.2"])
    end
  else
    s.add_dependency(%q<nokogiri>, ["> 0.0.0"])
    s.add_dependency(%q<loofah>, [">= 0.4.2"])
  end
end