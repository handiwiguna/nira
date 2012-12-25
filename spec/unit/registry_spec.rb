require 'spec_helper'

describe Nira::ParserRegistry do

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
      @registry.registered_parsers.count.should == 1
    end

    it "return the parser for supported url" do
      @registry.for("http://www.ebay.com").should == EbayParser
    end

    it "return nil for unsupported url" do
      @registry.for("http://www.etsy.com").should == nil
    end
  end

end
