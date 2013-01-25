module Nira
  module Parser
    class Base
      attr_reader :document, :source, :options

      def initialize(options={})
        @options = options
      end

      def can_parse?(url)
        self.class.can_parse?(url)
      end

      def title
        document and document.title
      end

      def description
        document and get_text("//meta[@name='description']/@content")
      end

      def images
        document and @images ||= get_collection("//img") do |attr|
          single_image(attr)
        end
      end

      def parse(document)
        url = document.url
        raise NotSuitableParserError unless can_parse?(url)
        @source = url
        @document = document.value
        self
      end

      protected

      def get_text(pattern)
        attribute = document.at(*pattern) and attribute.inner_text
      end

      def get_collection(pattern)
        collection = []
        images = document.xpath(*pattern)
        images.each do |attr|
          result = yield attr
          collection << result if result
        end
        collection
      end

      private

      def single_image(attr)
        src, width, height = attr["src"], attr["width"], attr["height"]
        return if src.nil? || src.empty? || src == "/"
        image = Nira::Image.new(url: Utils.absolutify_url(self.source, src),
                                width: width.to_i,
                                height: height.to_i)
        ImageChecker.new(image, options).result
      rescue URI::BadURIError, URI::InvalidURIError
        nil
      end
    end
  end
end
