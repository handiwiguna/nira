require 'spec_helper'

describe "Nira" do

  it ".get" do
    page = Nira.get('http://www.satutempat.com')
    page.title.should == "SatuTempat.com:  Shop Socially"
  end

end
