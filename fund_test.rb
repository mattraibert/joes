require 'minitest/autorun'
require 'fund'
require 'date'
require 'active_support/core_ext'

class FundTest < MiniTest::Unit::TestCase
  def test_interface
    date = Date.parse("2000-03-01")

    fund = Fund.new
    fund.write(date, 500)
    fund.write(date + 1.month , 600)
    
    assert_equal(500, fund.balance_for(date))
  end
end
