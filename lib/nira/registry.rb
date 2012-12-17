module Nira
  class ParserRegistry
    attr_reader :registered_parsers

    def initialize
      @registered_parsers = []
    end

    def add(parser)
      @registered_parsers << parser
    end

    def for(target)
      parser = @registered_parsers.find{|p| p.can_parse?(target)} and parser.new
    end
  end
end
