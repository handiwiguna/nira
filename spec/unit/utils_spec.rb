require 'spec_helper'

describe Nira::Utils do

  it ".normalize_url" do
    url = "http://www.example.com"
    Nira::Utils.normalize_url(url).should == 'http://www.example.com'

    url2 = "http://www.example. com"
    Nira::Utils.normalize_url(url2).should == 'http://www.example.%20com'
  end

  it ".absolutify_url" do
    base = "http://www.example.com"
    Nira::Utils.absolutify_url(base, "image.jpg").should == "http://www.example.com/image.jpg"
    Nira::Utils.absolutify_url(base, "/image 2.jpg").should == "http://www.example.com/image%202.jpg"
    Nira::Utils.absolutify_url(base, "assets/image 2.jpg").should == "http://www.example.com/assets/image%202.jpg"
    Nira::Utils.absolutify_url(base, "http://www.example.com/image 2.jpg").should == "http://www.example.com/image%202.jpg"

    base2 = "http://www.example.com/p/product-1"
    Nira::Utils.absolutify_url(base2, "/assets/image.jpg").should == "http://www.example.com/assets/image.jpg"
    Nira::Utils.absolutify_url(base2, "assets/image.jpg").should == "http://www.example.com/p/assets/image.jpg"
  end

end
