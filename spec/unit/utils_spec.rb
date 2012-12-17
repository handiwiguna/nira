require 'spec_helper'

describe Nira::Utils do

  it ".normalize_url" do
    url = "http://www.example.com"
    url_without_scheme = "www.example.com"
    Nira::Utils.normalize_url(url).should eql('http://www.example.com')
    # Nira::Utils.normalize_url(url_without_scheme).should eql('http://www.example.com')
  end

end
