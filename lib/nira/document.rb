require 'nokogiri'
require 'open-uri'

module Nira
  class Document
    attr_reader :value, :url

    def initialize(url)
      @url = Utils.normalize_url(url)
      @value = fetch_html(@url)
    end

    def self.fetch(url)
      new(url)
    end

    private

    def fetch_html(url)
      Nokogiri::HTML(open url)
    rescue URI::BadURIError, URI::InvalidURIError
      raise
    rescue
      raise FetchDocumentError
    end
  end
end
