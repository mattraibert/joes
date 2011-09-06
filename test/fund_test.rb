require 'minitest/autorun'
require 'fund'
require 'date'
require 'active_support/core_ext'

class FundTest < MiniTest::Unit::TestCase
  def test_balance
    date = Date.parse("2000-03-01")

    fund = Fund.new("My Fund")
    fund.write_balance(date, 500)
    fund.write_balance(date + 1.month , 600)

    assert_equal(500, fund.balance_for(date))
  end

  def test_contribution
    date = Date.parse("2000-03-01")

    fund = Fund.new("My Fund")
    fund.write_contribution(date, 500)
    fund.write_contribution(date + 1.month , 600)

    assert_equal(500, fund.contribution_for(date))
  end
end
