# encoding: utf-8
require 'rspec'
require 'rack/test'

MY_APP = Rack::Builder.parse_file('config.ru').first

include Rack::Test::Methods
def app
  MY_APP
end

describe "Convchar" do
  context "root" do
    it "last response ok?" do
      get '/'
      last_response.ok? == true
    end
  end

  context "convert" do
    it "last response ok?" do
      post '/convert'
      last_response.ok? == true
    end

    context "char to hex bytes" do
      it "encoding UTF-8" do
        post '/convert', {"before" => "あ",
                          "charset" => "UTF-8",
                          "way" => "0"} 
        last_response.ok? == true
        last_response.body.to_s.should =~ /e38182/
      end
    end
  end
end

