# a basic dom based extractor. it's a generic catch all
class Extractula::DomExtractor
  def extract url, html
    Extractula::ExtractedContent.new :url => url
  end
end
