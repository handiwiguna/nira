require "nira/parsers/opengraph"

module Nira
  module Parser
    class Generic
      include Base
      include Opengraph

      def self.can_parse?(url)
        true
      end

      def title
        og_title || super
      end

      def description
        og_description || super
      end
    end
  end
end
