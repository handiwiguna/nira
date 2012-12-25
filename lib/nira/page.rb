module Nira
  class Page
    attr_accessor :title, :description, :images

    def initialize(title, description, images)
      @title = title
      @description = description
      @images = images
    end
  end
end
