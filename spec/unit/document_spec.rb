require 'spec_helper'

describe Nira::Document do

  it "raise SocketError when url is not exists" do
    url = "http://www.example342423.com"
    expect { Nira::Document.new(url) }.to raise_error(SocketError)
  end

  it "raise FetchDocumentError when url has no scheme" do
    url = "www.example.com"
    expect { Nira::Document.new(url) }.to raise_error(FetchDocumentError)
  end
end
