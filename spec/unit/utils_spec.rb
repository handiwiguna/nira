require 'spec_helper'

describe Nira::Utils do

  describe ".normalize_url" do
    let(:url) { "http://www.example.com" }
    let(:url2) { "http://www.example. com" }

    it { Nira::Utils.normalize_url(url).should == "http://www.example.com" }
    it { Nira::Utils.normalize_url(url2).should == "http://www.example.%20com" }
  end

  describe ".absolutify_url" do
    let(:base) { "http://www.example.com" }
    let(:base2) { "http://www.example.com/p/product-1" }

    it { Nira::Utils.absolutify_url(base, "image.jpg").should == "http://www.example.com/image.jpg" }
    it { Nira::Utils.absolutify_url(base, "/image 2.jpg").should == "http://www.example.com/image%202.jpg" }
    it { Nira::Utils.absolutify_url(base, "assets/image 2.jpg").should == "http://www.example.com/assets/image%202.jpg" }
    it { Nira::Utils.absolutify_url(base, "http://www.example.com/image 2.jpg").should == "http://www.example.com/image%202.jpg" }
    it { Nira::Utils.absolutify_url(base2, "/assets/image.jpg").should == "http://www.example.com/assets/image.jpg" }
    it { Nira::Utils.absolutify_url(base2, "assets/image.jpg").should == "http://www.example.com/p/assets/image.jpg" }
  end

end
