require "minitest/autorun"

require 'active_record'
require 'pry'
require 'active_record/with'
ActiveRecord::Base.establish_connection(:adapter => 'postgresql', :host => "localhost", :port => ENV["BOXEN_POSTGRESQL_PORT"], :database => "with_test")
ActiveRecord::Base.connection.create_table(:monkeys, :force => true) do |t|
    t.string :name
    t.string :age
end

class Monkey < ActiveRecord::Base
end

class TestMeme < MiniTest::Unit::TestCase
  def setup
    @bobo = Monkey.create(:name => "Bobo", :age => 13)
    @kiki = Monkey.create(:name => "Kiki", :age => 15)
  end

  def test_that_can_query_with_with
    assert_equal [@bobo, @kiki], Monkey.with(some_monkeys: Monkey.order(:age)).to_a
  end
end