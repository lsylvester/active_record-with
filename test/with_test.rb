require "minitest/autorun"

require 'active_record'
require 'pry'
require 'active_record/with'
ActiveRecord::Base.establish_connection(:adapter => 'postgresql', :host => "localhost", :port => ENV["BOXEN_POSTGRESQL_PORT"], :database => "with_test")
ActiveRecord::Base.connection.create_table(:monkeys, :force => true) do |t|
    t.string :name
    t.integer :age
end

class Monkey < ActiveRecord::Base
end

class TestMeme < MiniTest::Unit::TestCase
  def setup
    ActiveRecord::Base.logger = Logger.new(STDOUT)
    Monkey.delete_all
    @bobo = Monkey.create(:name => "Bobo", :age => 13)
    @kiki = Monkey.create(:name => "Kiki", :age => 15)
  end

  def test_that_can_query_from_with
    assert_equal [@bobo, @kiki], Monkey.with(some_monkeys: Monkey.order(:age)).select("some_monkeys.*").from('some_monkeys').to_a
    assert_equal [@kiki, @bobo], Monkey.with(some_monkeys: Monkey.order(:age => :desc)).select("some_monkeys.*").from('some_monkeys').to_a
  end
  
  def test_that_can_query_joining_with
    assert_equal [@bobo], Monkey.with(young_monkeys: Monkey.where("age < ?",14)).joins('inner join young_monkeys on young_monkeys.id = monkeys.id').to_a
  end
end