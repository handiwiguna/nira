module Nira
  module Parser
    module Base
      attr_reader :document

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def can_parse?(url)
          false
        end
      end

      def can_parse?(url)
        self.class.can_parse?(url)
      end

      def title
        document and document.title
      end

      def description
        document and attr = document.at("//meta[@name='description']/@content") and attr.text
      end

      def parse(document)
        raise NotSuitableParserError,
          "#{self.class.to_s} can't parse #{document.url}" unless can_parse?(document.url)
        @document = document.value
        self
      end
    end
  end
end
