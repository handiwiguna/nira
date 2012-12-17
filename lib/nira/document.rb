require 'nokogiri'
require 'open-uri'

module Nira
  class Document
    attr_reader :value, :url

    def initialize(url)
      @url = url
      @value = Nokogiri::HTML(open url)
    end

    def self.fetch(url)
      new(url)
    end
  end
end
