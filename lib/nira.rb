require "nira/version"
require "nira/errors"
require "nira/document"
require "nira/page"
require "nira/factory"
require "nira/utils"

module Nira

  class << self

    def get(url)
      url = Utils.normalize_url(url)
      factory = PageFactory.new url, parser: parsers.for(url)
      factory.create
    end

    def parsers
      @registry ||= ParserRegistry.new
    end

  end
end

require "nira/registry"
require "nira/parsers/base"
require "nira/parsers/generic"
