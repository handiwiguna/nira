require 'spec_helper'

describe Nira::Parser::Base do

  class ExampleParser < Nira::Parser::Base
  end

  before :each do
    @parser = ExampleParser.new
  end

  it "should be nil" do
    @parser.document.should == nil
    @parser.title.should == nil
    @parser.description.should == nil
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
          <body>
            <img src="http://www.example.com/image1.jpg">
            <img src="image 2.jpg">
            <img src="http://www.example.com/image3.jpg" width="100" height="200">
            <img src="image4.jpg" width="50">
            <img src="image5.jpg" width="50" height="50">
            <img src="image6.jpg" height="120">
            <img src="image7.jpg" width="80" height="120">
            <img src=""/>
            <img src="/"/>
            <img/>
          </body>
        </html>
      HTML
      @document = stub(url: "http://www.example.com", value: Nokogiri::HTML(html))
      @result = @parser.parse(@document)
    end

    it "return title: Book1" do
      @result.title.should == "Book1"
    end

    it "return description: Description" do
      @result.description.should == "about ruby programming"
    end

    it "return all images" do
      @result.images.should =~ ["http://www.example.com/image1.jpg",
                                "http://www.example.com/image%202.jpg",
                                "http://www.example.com/image3.jpg",
                                "http://www.example.com/image4.jpg",
                                "http://www.example.com/image5.jpg",
                                "http://www.example.com/image6.jpg",
                                "http://www.example.com/image7.jpg"]
      @result.images.count.should == 7
    end

    it "return images with minimal size requirement" do
      parser = ExampleParser.new(:min_size => "100x100")
      parser.stub(can_parse?: true)
      result = parser.parse(@document)
      result.images.should =~ ["http://www.example.com/image1.jpg",
                                "http://www.example.com/image%202.jpg",
                                "http://www.example.com/image3.jpg"]
      result.images.count.should == 3
    end
  end

end
