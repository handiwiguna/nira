require "nira/version"
require "nira/errors"
require "nira/document"
require "nira/page"
require "nira/factory"
require "nira/utils"

require 'nira/image'
require 'nira/image_checker'

module Nira

  class << self

    def get(url, options={})
      options.merge!(parser: parsers.for(url))
      factory = PageFactory.new(url, options)
      factory.create
    end

    def parsers
      @registry ||= ParserRegistry.new
    end

  end
end

require "nira/registry"
require "nira/parsers/base"
require "nira/parsers/opengraph"
require "nira/parsers/generic"
