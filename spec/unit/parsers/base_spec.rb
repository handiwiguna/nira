require 'spec_helper'

describe Nira::Parser::Base do

  class ExampleParser
    include Nira::Parser::Base
  end

  before :each do
    @parser = ExampleParser.new
  end

  it "should be nil" do
    @parser.document.should be_nil
    @parser.title.should be_nil
    @parser.description.should be_nil
  end

  it "return NotSuitableParserError" do
    @parser.stub(can_parse?: false)
    document = stub(url: "imposible", value: nil)
    lambda{@parser.parse(document)}.should raise_error(NotSuitableParserError)
  end

  context "parse a document" do
    before :each do
      @parser.stub(can_parse?: true)
      html = <<-HTML
        <html>
          <head>
            <title>Book1</title>
            <meta name="description" content="about ruby programming"/>
          </head>
        </html>
      HTML
      document = stub(url: "http://www.example.com", value: Nokogiri::HTML(html))
      @result = @parser.parse(document)
    end

    it "return title: Book1" do
      @result.title.should eql("Book1")
    end

    it "return description: Description" do
      @result.description.should eql("about ruby programming")
    end
  end

end
