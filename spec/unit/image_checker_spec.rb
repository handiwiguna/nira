require 'spec_helper'
require 'ostruct'

describe Nira::ImageChecker do

  it "check default value" do
    checker = Nira::ImageChecker.new(nil)
    checker.eager_check.should == false
    checker.min_size.should == nil
    checker.min_width.should == nil
    checker.min_height.should == nil
  end

  it "minimal width and height only available when min_size defined" do
    checker = Nira::ImageChecker.new(nil, min_size: "100x200")
    checker.min_size.should == "100x200"
    checker.min_width.should == 100
    checker.min_height.should == 200
  end

  it ".check_image_existence" do
    image = Nira::Image.new(url: 'http://www.example.com/image.jpg')
    image.stub(meta: OpenStruct.new(size: nil))
    checker = Nira::ImageChecker.new(image)
    checker.check_image_existence.should == false

    image.stub(meta: OpenStruct.new(size: [20,20]))
    checker = Nira::ImageChecker.new(image)
    checker.check_image_existence.should == true
  end

  it ".check_min_size" do
    image = Nira::Image.new(url: 'http://www.example.com/image.jpg')
    checker = Nira::ImageChecker.new(image, min_size: "100x100")
    checker.check_min_size(20, 20).should == false
    checker.check_min_size(20, 200).should == false
    checker.check_min_size(200, 20).should == false
    checker.check_min_size(200, 200).should == true
  end

  it "checking image size tag" do
    large_image = Nira::Image.new(url: 'http://www.example.com/image.jpg', width: 100, height: 100)
    checker = Nira::ImageChecker.new(large_image, min_size: "100x100")
    checker.result.should == large_image.url

    small_image = Nira::Image.new(url: 'http://www.example.com/image.jpg', width: 10, height: 20)
    checker = Nira::ImageChecker.new(small_image, min_size: "100x100")
    checker.result.should == nil
  end

  context "eager checking" do
    before :each do
      @options = {eager_check: true}
    end

    it "image not exist" do
      image = Nira::Image.new(url: 'http://www.example.com/image.jpg')
      checker = Nira::ImageChecker.new(image, @options)
      checker.stub(check_image_existence: false)
      checker.result.should == nil
    end

    it "image smaller than requirement" do
      image = Nira::Image.new(url: 'http://www.example.com/image.jpg')
      image.stub(meta: OpenStruct.new(size: [20,20]))
      checker = Nira::ImageChecker.new(image, @options.merge(min_size: "100x100"))
      checker.result.should == nil
    end

    it "image smaller than requirment but not checked/required" do
      image = Nira::Image.new(url: 'http://www.example.com/image.jpg')
      image.stub(meta: OpenStruct.new(size: [20,20]))
      checker = Nira::ImageChecker.new(image, @options)
      checker.result.should == image.url
    end

    it "should passed the requirement" do
      large_image = Nira::Image.new(url: 'http://www.example.com/image.jpg',
                                    width: 100, height: 100)
      large_image.stub(meta: OpenStruct.new(size: [100,100]))
      checker = Nira::ImageChecker.new(large_image, @options.merge(min_size: "100x100"))
      checker.result.should == large_image.url
    end
  end
end
