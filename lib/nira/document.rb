require 'nokogiri'
require 'open-uri'

module Nira
  class Document
    attr_reader :value, :url

    def initialize(doc_url)
      @url = Utils.normalize_url(doc_url)
      @value = fetch_html
    rescue URI::BadURIError, URI::InvalidURIError, SocketError
      raise
    rescue
      raise FetchDocumentError
    end

    def self.fetch(url)
      new(url)
    end

    private

    def fetch_html
      Nokogiri::HTML(open url)
    end
  end
end
