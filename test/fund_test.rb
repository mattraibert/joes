require 'minitest/autorun'
require 'fund'
require 'date'
require 'active_support/core_ext'

class FundTest < MiniTest::Unit::TestCase
  def setup
    @date = Date.parse("2000-03-01") 
    @fund = Fund.new("My Fund")
  end

  def test_balance
    @fund.write_balance(@date, 500)
    @fund.write_balance(@date + 1.month , 600)

    assert_equal(500, @fund.balance_for(@date))
  end

  def test_contribution
    @fund.write_contribution(@date, 500)
    @fund.write_contribution(@date + 1.month , 600)

    assert_equal(500, @fund.contribution_for(@date))
  end

  def test_units
    @fund.write_units(@date, 4.336)
    @fund.write_units(@date + 1.month, 4.92)

    assert_equal(4.336, @fund.units_for(@date))
  end

  def test_delta_units
    @fund.write_units(@date, 4.3)
    @fund.write_units(@date + 1.month, 4.5)

    assert_equal(4.3, @fund.delta_units_for(@date))
#    assert_equal(0.2, @fund.delta_units_for(@date + 1.month))
  end
end
