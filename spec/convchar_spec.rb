require 'rspec'
require 'rack/test'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

include Rack::Test::Methods
def app
  OUTER_APP
end

describe "Convchar" do
  it "test_root" do
    get '/'
    last_response.ok? == true
  end
end

