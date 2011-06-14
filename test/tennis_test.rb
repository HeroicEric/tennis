ENV['RACK_ENV'] = 'test'

require 'tennis'
require 'test/unit'
require 'rack/test'

class EvalTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_it_says_hello_world
    get '/hello'
    assert last_response.ok?
    assert_equal 'Hello World', last_response.body
  end

end
