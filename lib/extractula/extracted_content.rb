class Extractula::ExtractedContent
  attr_reader :url, :title, :summary, :content, :image_urls, :video_embed

  def initialize(attributes = {})
    attributes.each_pair {|k, v| instance_variable_set("@#{k}", v)}
  end
end
