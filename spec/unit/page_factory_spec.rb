require 'spec_helper'
require 'ostruct'

class AmazonParser < Nira::Parser::Base
end

describe Nira::PageFactory do
  let(:factory) { Nira::PageFactory.new("http://www.example.com") }

  it { factory.url.should == ("http://www.example.com") }
  it { factory.parser.class.should == Nira::Parser::Generic }
  it "return nil when parse an nil document" do
    factory.stub(parser_result: nil)
    factory.create.should == nil
  end

  describe "#create" do
    subject { factory.create }
    before :each do
      factory.stub(parser_result: OpenStruct.new(title: "Book1",
                                                 description: "Ruby Programming",
                                                 images: ["http://www.example.com/image1.jpg"]))
    end
    its(:class)       { should == Nira::Page }
    its(:title)       { should == "Book1" }
    its(:description) { should == "Ruby Programming" }
    its(:images)      { should =~ ["http://www.example.com/image1.jpg"] }
  end

  describe "custom parser" do
    let(:factory) { Nira::PageFactory.new("http://www.example.com", parser: AmazonParser) }
    it { factory.parser.class.should == AmazonParser }
  end

end
