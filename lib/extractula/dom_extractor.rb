# a basic dom based extractor. it's a generic catch all
class Extractula::DomExtractor < Extractula::Extractor
  use_defaults :title, :content, :summary
end
