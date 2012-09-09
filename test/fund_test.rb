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

    assert_equal(Units.new(4.336), @fund.units_for(@date))
  end

  def test_delta_units
    @fund.write_units(@date, 4.3)
    @fund.write_units(@date + 1.month, 4.5)
    @fund.write_units(@date + 1.month + 1.day, 4.9)

    assert_equal(Units.new(4.3), @fund.delta_units_for(@date))
    assert_equal(Units.new(0.2), @fund.delta_units_for(@date + 1.month))
    assert_equal(Units.new(0.4), @fund.delta_units_for(@date + 1.month + 1.day))
  end

  def test_find_units_backwards
    @fund.write_units(@date, 4.1)
    @fund.write_units(@date + 1.day, 4.3)

    assert_equal(Units.zero, @fund.find_units_backwards(@date))
    assert_equal(Units.new(4.1), @fund.find_units_backwards(@date + 1.day))
    assert_equal(Units.new(4.3), @fund.find_units_backwards(@date + 2.days))
    assert_equal(Units.new(4.3), @fund.find_units_backwards(@date + 1.month))
  end
end
