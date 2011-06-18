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

  def db_am
    DataMapper::auto_migrate!
  end

  def range_rand(min,max)
    min + rand(max-min)
  end


  def load_fresh_data
    # Empty the Database
    db_am

    # Create 100 Instructors
    (1..100).each do |i|
      Instructor.create(
        :name => "Instructor ##{i}",
        :username => "username#{i}",
        :location => Forgery(:address).street_address + ", " + Forgery(:address).city + ", " + Forgery(:address).state + " " + Forgery(:address).zip,
        :lat => 41.513423,
        :lng => -72.8464738,
        :bio => Forgery(:loremIpsum).paragraphs(range_rand(1, 5)),
        :rate => range_rand(1, 5),
        :rating => range_rand(1, 5)
      )
    end

    # Create 100 Courts
    (1..100).each do |i|
      Court.create(:name => "Court ##{i}")
    end

  end

  def test_users_created
    load_fresh_data

    Instructor.each do |ins|
      get '/instructor/' + ins.username
      assert last_response.ok?
    end

  end

  def test_create_appointment_slots
    load_fresh_data

    (1..100).each do |i|
      options = {
        :sTime =>
    end
  end

end
