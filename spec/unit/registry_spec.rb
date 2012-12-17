require 'spec_helper'

describe "Registry" do

  class EbayParser
    def self.can_parse?(url)
      url == "http://www.ebay.com"
    end
  end

  context "when register parser" do
    before :each do
      @registry = Nira::ParserRegistry.new
      @registry.add(EbayParser)
    end

    it "return 1 registered parser" do
      @registry.registered_parsers.count.should eql(1)
    end

    it "return the parser for supported url" do
      @registry.for("http://www.ebay.com").class.should eql(EbayParser)
    end

    it "return nil for unsupported url" do
      @registry.for("http://www.etsy.com").should be_nil
    end
  end

end
