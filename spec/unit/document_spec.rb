require 'spec_helper'

describe Nira::Document do

  it "invalid uri should raise error" do
    url = "http://www.example. com"
    lambda{Nira::Document.new(url).should}.should raise_error(FetchDocumentError)
  end

  it "not include protocol should raise error" do
    url = "www.example.com"
    lambda{Nira::Document.new(url).should}.should raise_error(FetchDocumentError)
  end
end
