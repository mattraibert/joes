require 'minitest/autorun'
require '../src/investments'
require 'date'
require 'active_support/core_ext'

class InvestmentsTest < MiniTest::Unit::TestCase
  def test_csv
    rd = Investments.new
    expected_csv = ["Date, iShares Raibert Fund, ANOTHER Fund, TOTAL",
     "2008-01-01, 50000, 40000, 90000",
     "2008-01-02, 50001, 40001, 90002"].join("\n")

    irf = rd.fund("iShares Raibert Fund")
    irf.write_balance(Date.parse("2008-01-01"), 50000)
    irf.write_balance(Date.parse("2008-01-02"), 50001)

    af = rd.fund("ANOTHER Fund")
    af.write_balance(Date.parse("2008-01-01"), 40000)
    af.write_balance(Date.parse("2008-01-02"), 40001)

    total = rd.fund("TOTAL")
    total.write_balance(Date.parse("2008-01-01"), 90000)
    total.write_balance(Date.parse("2008-01-02"), 90002)

    assert_equal(expected_csv, rd.csv)
  end

  def test_gives_you_the_same_fund
    investments = Investments.new
    
    fund = investments.fund "Raibert Fund"
    
    assert_equal(fund, investments.fund("Raibert Fund"))
  end

end
