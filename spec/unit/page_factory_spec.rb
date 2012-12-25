require 'spec_helper'
require 'ostruct'

describe Nira::PageFactory do

  context "with DefaultParser" do
    before :each do
      @factory = Nira::PageFactory.new('http://www.example.com')
    end

    it "return http://www.example.com" do
      @factory.url.should == ("http://www.example.com")
    end

    it "return Nira::Parser::Default instance" do
      @factory.parser.class.should == Nira::Parser::Generic
    end
  end

  context "with AmazonParser" do
    class AmazonParser < Nira::Parser::Base; end

    before :each do
      @factory = Nira::PageFactory.new('http://www.amazon.com', parser: AmazonParser)
    end

    it "return AmazonParser instance" do
      @factory.parser.class.should == AmazonParser
    end

    it "return nil when parse an nil document" do
      @factory.stub(parser_result: nil)
      @factory.create.should == nil
    end

    context "when parse a document" do
      before :each do
        @factory.stub(parser_result: OpenStruct.new(title: "Book1", 
                                                    description: "RubyProgramming",
                                                    images: ["http://www.example.com/image1.jpg"]))
        @page = @factory.create
      end

      it "return page instance" do
        @page.class.should == Nira::Page
      end

      it "return title: 'Book1'" do
        @page.title.should == "Book1"
      end

      it "return description: 'RubyProgramming'" do
        @page.description.should == "RubyProgramming"
      end

      it "return images" do
        @page.images.should =~ ["http://www.example.com/image1.jpg"]
      end
    end
  end

end
