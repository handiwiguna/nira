require 'spec_helper'

describe "Nira Page" do

  it "testing factory" do
    a = Nira::PageFactory.new('http://www.satutempat.com')
    page = a.create
    page.title.should == "SatuTempat.com:  Shop Socially"
    page.description.should be_nil
  end

  it "test Nira get" do
    n = Nira.get('http://www.satutempat.com')
    n.title.should == "SatuTempat.com:  Shop Socially"
  end
end
