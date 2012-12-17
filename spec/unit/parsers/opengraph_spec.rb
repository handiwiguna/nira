require 'spec_helper'

class ExampleParser
  include Nira::Parser::Base
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
        </head>
      </html>
    HTML
    document = stub(url: "http://www.example.com", value: Nokogiri::HTML(html))
    @result = @parser.parse(document)
  end

  it "return og_title" do
    @result.og_title.should eql("og-title")
  end

  it "return og_description" do
    @result.og_description.should eql("og-description")
  end
end
