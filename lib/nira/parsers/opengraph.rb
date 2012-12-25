module Nira
  module Parser
    module Opengraph

      OG_TITLE_TAG = 'og:title'
      OG_DESCRIPTION_TAG = 'og:description'
      OG_IMAGE_TAG = 'og:image'

      def og_title
        document and get_text(pattern(OG_TITLE_TAG))
      end

      def og_description
        document and get_text(pattern(OG_DESCRIPTION_TAG))
      end

      def og_images
        document and @og_images ||= get_collection(pattern(OG_IMAGE_TAG)) do |attr|
          single_og_image(attr)
        end
      end

      private

      def single_og_image(attr)
        href = attr.inner_text
        return if href.nil? || href.empty? || href == "/"
        image = Nira::Image.new(:url => Utils.absolutify_url(self.source, href))
        ImageChecker.new(image, options).result
      rescue URI::BadURIError, URI::InvalidURIError
        nil
      end

      def pattern(tag)
        ["//meta[@property='#{tag}']/@content",
         "//meta[@name='#{tag}']/@content"]
      end
    end
  end
end
