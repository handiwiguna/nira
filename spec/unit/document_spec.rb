require 'spec_helper'

describe Nira::Document do

  let(:url) { "http://www.example.com/dua tiga.html"}
  let(:document) { stub(url: url, value: Nokogiri::HTML(html)) }
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

  it "should raise FetchDocumentError" do
    Nira::Document.any_instance.should_receive(:fetch_html) { raise StandardError }
    expect { Nira::Document.new(url) }.to raise_error(FetchDocumentError)
  end

  it ".fetch" do
    Nira::Document.any_instance.should_receive(:open).and_return(html)
    doc = Nira::Document.fetch(url)
    doc.url.should == "http://www.example.com/dua%20tiga.html"
    doc.value.should_not == nil
    doc.value.class.should == Nokogiri::HTML::Document
  end

end
