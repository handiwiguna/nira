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

    let(:url) { "http://www.example.com" }
    let(:document) { stub(url: url, value: Nokogiri::HTML(html)) }
    let(:html) { <<-HTML
      <html>
        <head>
          <title>Book1</title>
          <meta name="description" content="Ruby Programming"/>
          <meta property="og:image" content="http://www.example.com/image1.jpg"/>
        </head>
      </html>
      HTML
    }
    before :each do
      Nira::Document.should_receive(:fetch).with(url).and_return(document)
    end
    its(:class)       { should == Nira::Page }
    its(:title)       { should == "Book1" }
    its(:description) { should == "Ruby Programming" }
    its(:images)      { should =~ ["http://www.example.com/image1.jpg"] }
  end

  describe "custom parser" do
    let(:factory) { Nira::PageFactory.new("http://www.example.com", parser: AmazonParser, :min_size => "50x50") }
    it { factory.parser.class.should == AmazonParser }
    it { factory.parser.options.count.should == 1}
  end

end
