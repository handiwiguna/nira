require 'spec_helper'
require 'ostruct'

describe Nira::ImageChecker do

  let(:checker) { Nira::ImageChecker.new(image, checker_options) }
  let(:checker_options) { {} }
  let(:image) { nil }
  let(:image_options) { {} }

  describe "check value" do
    it { checker.eager_check.should == false }
    it { checker.min_size.should == nil }
    it { checker.min_width.should == nil }
    it { checker.min_height.should == nil }

    context "with minimal size defined (100x200)" do
      let(:checker_options) { {min_size: "100x200"} }
      it { checker.min_width.should == 100 }
      it { checker.min_height.should == 200 }
    end
  end

  describe "#image_exists?" do
    subject { checker.image_exists? }

    context "when image not exists" do
      let(:image) { stub(meta: OpenStruct.new(size: nil)) }
      it { should == false }
    end

    context "when image exists" do
      let(:image) { stub(meta: OpenStruct.new(size: [20, 20])) }
      it { should == true }
    end
  end

  describe "#greater_than_minimal_size?" do
    let(:checker_options) { {min_size: "100x100"} }
    it { checker.greater_than_minimal_size?(20, 20).should == false }
    it { checker.greater_than_minimal_size?(20, 200).should == false }
    it { checker.greater_than_minimal_size?(200, 20).should == false }
    it { checker.greater_than_minimal_size?(200, 200).should == true }
  end

  describe "#result" do
    subject { checker.result }
    let(:image) { Nira::Image.new(image_options.merge(url: "http://www.example.com/image.jpg")) }

    context "when both width & height tag defined" do
      let(:image_options) { {width: 100, height: 100} }

      it "return the url (size >= min_size)" do
        checker_options.merge!(min_size: "100x100")
        should == image.url
      end

      it "return nil (size < min_size)" do
        checker_options.merge!(min_size: "200x100")
        should == nil
      end
    end

    context "when only width tag defined" do
      let(:image_options) { {width: 100} }

      it "return nil (width:100, min_size: 50x50)" do
        checker_options.merge!(min_size: "50x50")
        should == nil
      end
    end

    context "when only height tag defined" do
      let(:image_options) { {height: 100} }

      it "return nil (height:100, min_size: 50x50)" do
        checker_options.merge!(min_size: "50x50")
        should == nil
      end
    end

    context "when eager checking" do
      let(:checker_options) { {eager_check: true} }

      it "return nil (image size not defined)" do
        image.stub(meta: OpenStruct.new(size: nil))
        checker_options.merge!(min_size: "100x100")
        should == nil
      end

      it "return nil (image smaller than size requirement)" do
        image.stub(meta: OpenStruct.new(size: [20, 20]))
        checker_options.merge!(min_size: "100x100")
        should == nil
      end

      it "return the url (no size requirement)" do
        image.stub(meta: OpenStruct.new(size: [20, 20]))
        should == image.url
      end

      it "return the url (size >= min_size)" do
        image.stub(meta: OpenStruct.new(size: [100, 100]))
        checker_options.merge!(min_size: "100x100")
        should == image.url
      end
    end
  end
end
