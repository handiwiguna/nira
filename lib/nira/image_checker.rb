module Nira
  class ImageChecker

    attr_reader :image, :eager_check, :min_size, :min_width, :min_height

    def initialize(image, options={})
      @image = image
      @eager_check = options[:eager_check] || false
      if @min_size = options[:min_size]
        @min_width, @min_height = @min_size.split("x").map(&:to_i)
      end
    end

    def result
      passed = true
      passed &&= greater_than_minimal_size?(image.width, image.height) if image.have_size_tag? && min_size

      if eager_check
        passed &&= image_exists?
        passed &&= greater_than_minimal_size?(*(image.meta.size || [0, 0])) if min_size
      end

      passed ? image.url : nil
    end

    def image_exists?
      !image.meta.size.nil?
    end

    def greater_than_minimal_size?(width, height)
      (width >= min_width) && (height >= min_height)
    end
  end
end
