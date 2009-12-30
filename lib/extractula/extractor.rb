# Abstract (more or less) extractor class from which custom extractor
# classes should descend. Subclasses of Extractula::Extractor will be
# automatically added to the Extracula module.

module Extractula
  class Extractor
    
    def self.inherited subclass
      Extractula.add_extractor subclass
    end
    
    def self.can_extract? url, html
      false
    end
    
    def extract url, html
      Extractula::ExtractedContent.new
    end

  end
end