class Extractula::ExtractedContent
  attr_reader :url, :title, :content, :summary, :image_urls, :video_embed

  def initialize(attributes = {})
    attributes.each_pair {|k, v| instance_variable_set("@#{k}", v)}
  end

  def summary
    return @summary if @summary
    @content_doc ||= Nokogiri::HTML(@content)
    content_fragment = @content_doc.inner_text.slice(0, 350)
    sentence_break = content_fragment.rindex(/\?|\.|\!|\;/)
    if sentence_break
      @summary = content_fragment.slice(0, sentence_break + 1)
      @summary
    else
      @summary = content_fragment
    end
  end

  def image_urls
    return @image_urls if @image_urls
    @content_doc ||= Nokogiri::HTML(@content)
    @image_urls = @content_doc.search("//img").collect {|t| t["src"]}
  end

  def video_embed
    return @video_embed if @video_embed
    @content_doc ||= Nokogiri::HTML(@content)
    @content_doc.search("//object").collect {|t| t.to_html}.first
  end
end
