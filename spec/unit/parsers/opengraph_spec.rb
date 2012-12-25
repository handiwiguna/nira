require 'spec_helper'

class ExampleParser < Nira::Parser::Base
  include Nira::Parser::Opengraph

  def self.can_parse?(url)
    true
  end
end

describe Nira::Parser::Opengraph do
  before :each do
    @parser = ExampleParser.new
    html = <<-HTML
      <html>
        <head>
          <meta property="og:title" content="og-title"/>
          <meta property="og:description" content="og-description"/>
          <meta property="og:image" content=""/>
          <meta property="og:image" content="/"/>
          <meta property="og:image" content= />
          <meta property="og:image" />
          <meta property="og:image" content="image 2.jpg"/>
        </head>
        <meta property="og:image" content="http://www.example.com/image1.jpg"/>
      </html>
    HTML
    document = stub(url: "http://www.example.com", value: Nokogiri::HTML(html))
    @result = @parser.parse(document)
  end

  it "return og_title" do
    @result.og_title.should == "og-title"
  end

  it "return og_description" do
    @result.og_description.should == "og-description"
  end

  it "return og_images" do
    @result.og_images.should =~ ["http://www.example.com/image1.jpg",
                                 "http://www.example.com/image%202.jpg"]
    @result.og_images.count.should == 2
  end
end
