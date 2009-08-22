require 'test_helper'
require 'gem_watch/check'

class CheckTest < Test::Unit::TestCase
  context "an empty check" do
    setup do
      @check = GemWatch::Check.new
    end
    
    should "@impacts be an empty hash at initialization" do
      assert_kind_of Hash, @check.impacts
      assert @check.impacts.empty?
    end
  
    should "passed? returns true if @impacts is empty" do
      assert @check.passed?
    end
  end
end