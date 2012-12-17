module Nira
  module Parser
    module Opengraph

      OG_TITLE_TAG = 'og:title'
      OG_DESCRIPTION_TAG = 'og:description'

      def og_title
        get_content(OG_TITLE_TAG)
      end

      def og_description
        get_content(OG_DESCRIPTION_TAG)
      end

      private

      def get_content(og_tag)
        attribute = document.at("//meta[@property='#{og_tag}']/@content",
                                "//meta[@name='#{og_tag}']/@content") and attribute.inner_text
      end
    end
  end
end
