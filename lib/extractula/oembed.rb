require 'typhoeus'
require 'json'

module Extractula
  module OEmbed
    
    def self.included(base)
      base.class_eval {
        extend  Extractula::OEmbed::ClassMethods
        include Extractula::OEmbed::InstanceMethods
      }
    end
    
    def self.request(request)
      http_response = Typhoeus::Request.get(request)
      if http_response.code == 200
        Extractula::OEmbed::Response.new(http_response.body)
      else
        # do something
      end
    end
    
    module ClassMethods 
      def oembed_endpoint(url = nil)
        if url
          @oembed_endpoint = url
          if @oembed_endpoint.match(/\.(xml|json)$/)
            @oembed_format_param_required = false
            @oembed_endpoint.sub!(/\.xml$/, '.json') if $1 == 'xml'
          else
            @oembed_format_param_required = true
          end
        end
        @oembed_endpoint
      end
      
      def oembed_max_width(width = nil)
        @oembed_max_width = width if width
        @oembed_max_width
      end
      
      def oembed_max_height(height = nil)
        @oembed_max_height = height if height
        @oembed_max_height
      end
      
      def oembed_format_param_required?
        @oembed_format_param_required
      end
    end
    
    module InstanceMethods
      def initialize(*args)
        super
        @oembed = Extractula::OEmbed.request(oembed_request)
      end
      
      def oembed_endpoint
        self.class.oembed_endpoint
      end
      
      def oembed_max_width
        self.class.oembed_max_width
      end
      
      def oembed_max_height
        self.class.oembed_max_height
      end
      
      def oembed_format_param_required?
        self.class.oembed_format_param_required?
      end
      
      def oembed
        @oembed
      end
      
      def oembed_request
        request = "#{oembed_endpoint}?url=#{url.url}"
        request += "&format=json" if oembed_format_param_required?
        request += "&maxwidth=#{oembed_max_width}" if oembed_max_width
        request += "&maxheight=#{oembed_max_height}" if oembed_max_height
        request
      end
      
      def title
        oembed.title
      end
      
      def image_urls
        [ oembed.url ] if oembed.type == 'photo'
      end
      
      def video_embed
        oembed.html
      end
    end
    
    class Response
      
      FIELDS = %w{ type version title author_name author_url
                  provider_name provider_url cache_age thumbnail_url
                  thumbnail_width thumbnail_height }

      FIELDS.each { |field| attr_reader field.to_sym }
      attr_reader :width, :height, :url, :html

      def initialize response
        @doc    = ::JSON.parse(response)
        FIELDS.each { |field| instance_variable_set "@#{field}", @doc[field] }
        unless @type == 'link'
          @width  = @doc['width']
          @height = @doc['height']
          if @type == 'photo'
            @url = @doc['url']
          else
            @html = @doc['html']
          end
        end
        
        def [](field)
          @doc[field]
        end
      end
      
    end
  end
end