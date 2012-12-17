module Nira
  class PageFactory
    attr_reader :url, :parser

    def initialize(url, options={})
      @url = url
      @parser = options.delete(:parser) || Parser::Generic.new
    end

    def document
      @document ||= Document.fetch(url)
    end

    def create
      return unless parser_result
      Page.new(parser_result.title, parser_result.description)
    end

    def parser_result
      parser.parse(document)
    end

  end
end

