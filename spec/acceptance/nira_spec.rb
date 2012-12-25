require 'spec_helper'

describe "Nira" do

  it "testing factory" do
    a = Nira::PageFactory.new('http://www.satutempat.com')
    page = a.create
    page.title.should == "SatuTempat.com:  Shop Socially"
    page.description.should == nil
  end

  it "test Nira get" do
    n = Nira.get('http://www.satutempat.com')
    n.title.should == "SatuTempat.com:  Shop Socially"
  end

  it "URL not valid" do
    lambda {Nira.get("example.com")}.should raise_error(FetchDocumentError)
    lambda {Nira.get("http://www.example. com")}.should raise_error(FetchDocumentError)
  end
end
