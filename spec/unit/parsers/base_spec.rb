require 'spec_helper'

class ExampleParser < Nira::Parser::Base
  def self.can_parse?(url)
    true
  end
end

describe Nira::Parser::Base do
  let(:parser) { ExampleParser.new(options)}
  let(:options) { {} }

  its(:document)    { should == nil }
  its(:title)       { should == nil }
  its(:description) { should == nil }

  it "return NotSuitableParserError" do
    parser.stub(can_parse?: false)
    document = stub(url: "http://cantparse.com", value: nil)
    expect {parser.parse(document)}.to raise_error(NotSuitableParserError)
  end

  describe "#parse" do
    let(:html) { <<-HTML
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
    }
    let(:document) { stub(url: "http://www.example.com", value: Nokogiri::HTML(html)) }
    subject(:result){ parser.parse(document)}

    its(:title)       { should == "Book1" }
    its(:description) { should == "about ruby programming" }
    its(:images)      { should =~ ["http://www.example.com/image1.jpg",
                                   "http://www.example.com/image%202.jpg",
                                   "http://www.example.com/image3.jpg",
                                   "http://www.example.com/image4.jpg",
                                   "http://www.example.com/image5.jpg",
                                   "http://www.example.com/image6.jpg",
                                   "http://www.example.com/image7.jpg"] }

    it "return only valid images" do
      options.merge!(min_size: "100x100")
      result.images.should =~ ["http://www.example.com/image1.jpg",
                                "http://www.example.com/image%202.jpg",
                                "http://www.example.com/image3.jpg"]
    end
  end

end
