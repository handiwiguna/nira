require 'spec_helper'

class ExampleParser < Nira::Parser::Base
  include Nira::Parser::Opengraph
  def self.can_parse?(url)
    true
  end
end

describe Nira::Parser::Opengraph, "#parse" do
  subject { parser.parse(document) }

  let(:parser) { ExampleParser.new }
  let(:document) { stub(url: "http://www.example.com", value: Nokogiri::HTML(html)) }
  let(:html) { <<-HTML
      <html>
        <head>
          <title>Title</title>
          <meta property="og:title" content="og-title"/>
          <meta property="og:title" content="og-title2"/>
          <meta property="og:description" content="og-description"/>
          <meta property="og:description" content="og-description2"/>
          <meta property="og:image" content=""/>
          <meta property="og:image" content="/"/>
          <meta property="og:image" content= />
          <meta property="og:image" />
          <meta property="og:image" content="image 2.jpg"/>
        </head>
        <meta property="og:image" content="http://www.example.com/image1.jpg"/>
      </html>
    HTML
  }

  its(:document)       { should be_instance_of(Nokogiri::HTML::Document) }
  its(:og_title)       { should == "og-title" }
  its(:og_description) { should == "og-description" }
  its(:og_images)      { should =~ ["http://www.example.com/image1.jpg",
                                    "http://www.example.com/image%202.jpg"] }
end
