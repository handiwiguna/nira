require 'spec_helper'
require 'ostruct'

describe "PageFactory" do

  context "with DefaultParser" do
    before :each do
      @factory = Nira::PageFactory.new('http://www.example.com')
    end

    it "return http://www.example.com" do
      @factory.url.should eql("http://www.example.com")
    end

    it "return Nira::Parser::Default instance" do
      @factory.parser.should be_instance_of(Nira::Parser::Generic)
    end
  end

  context "with AmazonParser" do
    class AmazonParser; end

    before :each do
      @parser = AmazonParser.new
      @factory = Nira::PageFactory.new('http://www.amazon.com', parser: @parser)
    end

    it "return AmazonParser instance" do
      @factory.parser.should be_instance_of(AmazonParser)
    end

    it "return nil when parse an nil document" do
      @factory.stub(parser_result: nil)
      @factory.create.should be_nil
    end

    context "when parse a document" do
      before :each do
        @factory.stub(parser_result: OpenStruct.new(title: "Book1", description: "RubyProgramming"))
        @page = @factory.create
      end

      it "return page instance" do
        @page.should be_instance_of(Nira::Page)
      end

      it "return title: 'Book1'" do
        @page.title.should eql("Book1")
      end

      it "return description: 'RubyProgramming'" do
        @page.description.should eql("RubyProgramming")
      end
    end
  end

end
