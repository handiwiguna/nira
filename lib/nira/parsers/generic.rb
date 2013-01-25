module Nira
  module Parser
    class Generic < Base
      include Opengraph

      def self.can_parse?(url)
        !!url
      end

      def title
        og_title || super
      end

      def description
        og_description || super
      end

      def images
        (og_images unless og_images.empty?) || super
      end
    end
  end
end
