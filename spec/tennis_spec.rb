require "#{File.dirname(__FILE__)}/spec_helper"

describe Tennis do
  include Rack::Test::Methods

  def app
    Tennis.new
  end

  specify 'should show the default index page' do
    get '/'
    last_response.should be_ok
  end

  specify 'should have more specs' do
    pending
  end
end
