require 'rspec'
require 'rack/test'

MY_APP = Rack::Builder.parse_file('config.ru').first

include Rack::Test::Methods
def app
  MY_APP
end

describe "Convchar" do
  context "root" do
    it "test_root" do
      get '/'
      last_response.ok? == true
    end
  end

  context "convert" do
    it "test_post" do
      post '/convert'
      last_response.ok? == true
    end
  end
end

