require 'test-unit'
require 'rack/test'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

class ConvcharTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  def test_root
    get '/'
    assert last_response.ok?
  end
end

