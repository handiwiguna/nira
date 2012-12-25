require 'spec_helper'

describe Nira::Parser::Generic do

  before :each do
    @parser = Nira::Parser::Generic.new
    html = <<-HTML
      <html>
        <head>
          <title>Book1</title>
          <meta name="description" content="about ruby programming"/>
          <meta property="og:title" content="og-title"/>
          <meta property="og:description" content="og-description"/>
          <meta property="og:image" content="http://www.example.com/image1.jpg"/>
        </head>
        <body>
          <img src="http://www.example.com/image2.jpg"/>
        </body>
      </html>
    HTML
    document = stub(url: "http://www.example.com", value: Nokogiri::HTML(html))
    @result = @parser.parse(document)
  end

  it "receive anything url" do
    @parser.can_parse?('url').should be_true
  end

  it "prioritize og_title" do
    @result.title.should == "og-title"
  end

  it "prioritize og_description" do
    @result.description.should == "og-description"
  end

  it "prioritize og_image" do
    @result.images.should =~ ["http://www.example.com/image1.jpg"]
    @result.images.count.should == 1
  end

  it "only image tag exists" do
    image_tag = <<-HTML
      <html>
        <head>
          <title>Book1</title>
          <meta property="og:image" content=""/>
        </head>
        <body>
          <img src="http://www.example.com/image1.jpg"/>
        </body>
      </html>
    HTML
    document = stub(url: "http://www.example.com", value: Nokogiri::HTML(image_tag))
    result = @parser.parse(document)
    result.images.should =~ ["http://www.example.com/image1.jpg"]
    result.images.count.should == 1
  end
end
