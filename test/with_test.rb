require "minitest/autorun"

require 'active_record'
require 'pry'
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
    Monkey.with(some_monkeys: Monkey.order(:age)).from(:some_monkeys).to_a.should == [@bobo, @kiki]
  end
end