require 'spec_helper'

describe Nira::ParserRegistry do

  class AmazonParser
    def self.can_parse?(url)
      url == "http://www.amazon.com"
    end
  end

  class EbayParser
    def self.can_parse?(url)
      url == "http://www.ebay.com"
    end
  end

  describe "register parser" do
    let(:registry) { Nira::ParserRegistry.new }

    before :each do
      registry.add(EbayParser)
      registry.add(AmazonParser)
    end

    it "return 1 registered parser" do
      registry.registered_parsers.count.should == 2
    end

    it "return the parser for supported url" do
      registry.for("http://www.ebay.com").should == EbayParser
    end

    it "return nil for unsupported url" do
      registry.for("http://www.etsy.com").should == nil
    end
  end

end
