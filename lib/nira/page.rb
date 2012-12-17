module Nira
  class Page
    attr_accessor :title, :description

    def initialize(title, description)
      @title = title
      @description = description
    end
  end
end
