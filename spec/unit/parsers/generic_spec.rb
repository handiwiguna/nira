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
        </head>
      </html>
    HTML
    document = stub(url: "http://www.example.com", value: Nokogiri::HTML(html))
    @result = @parser.parse(document)
  end

  it "receive anything url" do
    @parser.can_parse?('url').should be_true
  end

  it "prioritize og_title" do
    @result.title.should eql("og-title")
  end

  it "prioritize og_description" do
    @result.description.should eql("og-description")
  end

end
