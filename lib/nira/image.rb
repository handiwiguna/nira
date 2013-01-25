require 'fastimage'

module Nira
  class Image
    attr_accessor :url, :width, :height

    def initialize(attributes)
      self.url = attributes[:url]
      self.width = attributes.fetch(:width, 0)
      self.height = attributes.fetch(:height, 0)
    end

    def have_size_tag?
      width != 0 || height != 0
    end

    def meta
      @meta ||= FastImage.new(url)
    end
  end
end
