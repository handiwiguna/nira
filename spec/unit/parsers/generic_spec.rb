require 'spec_helper'

describe Nira::Parser::Generic do
  subject { parser.parse(document) }

  let(:parser) { Nira::Parser::Generic.new }
  let(:document) { stub(url: "http://www.example.com", value: Nokogiri::HTML(html)) }

  it "receive all url" do
    parser.can_parse?('http://anything.com').should == true
  end

  context "prioritize opengraph" do
    let(:html) { <<-HTML
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
    }
    its(:title)       { should == "og-title" }
    its(:description) { should == "og-description" }
    its(:images)      { should =~ ["http://www.example.com/image1.jpg"] }
  end

  context "with og:image empty" do
    let(:html) { <<-HTML
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
    }
    its(:images) { should =~ ["http://www.example.com/image1.jpg"] }
  end
end
