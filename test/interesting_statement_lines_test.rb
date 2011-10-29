require 'minitest/autorun'
require 'interesting_statement_lines'

class InterestingStatementLinesTest < MiniTest::Unit::TestCase
  def test_parse_funds
    file = InterestingStatementLines.new
    file.parse_funds("SPDR DJIA Trust iShares Dow Jones Select Dividend Index Fund iShares Russell 2000 Index Fund iShares Barclays 7-10 Year Treasury Bond Fund iShares Barclays Aggregate Bond Fund iShares Barclays TIPS Bond Fund iShares Cohen & Steers Realty Majors Index Fund iShares MSCI Emerging Markets Index Fund iShares MSCI EAFE Index Fund\n")

    assert(file.funds.include? "SPDR DJIA Trust")
    assert(file.funds.include? "TOTAL")
  end

  def test_parse_balances
    file = InterestingStatementLines.new
    file.parse_balances("$231.79 $246.12 $38.32 $517.14 $655.41 $651.67 $201.69 $597.55 $615.29 $3,754.98\n")

    assert(file.balances.include? 231.79)
    assert(file.balances.include? 3754.98)
  end

  def test_parse_date
    file = InterestingStatementLines.new
    file.parse_date("2000-06-01.txt")

    assert_equal(Date.new(2000, 6, 1), file.date)
  end

  def test_parse_contributions
    file = InterestingStatementLines.new
    file.parse_contributions("$67.01 $59.10 $52.08 $341.08 $462.42 $719.60 $144.97 $280.61 $354.63 $2,481.50 $16.15 $16.15 $0.00 $12.92 $16.15 $0.00 $11.31 $48.47 $40.39 $161.54 $0.00 $0.00 $0.00 $0.00 $0.00 $0.00 $0.00 $0.00 $0.00 $0.00")

    assert(file.contributions.include? 161.54)
    assert(file.contributions.include? 16.15)
    assert(!file.contributions.include?(2481.5))
  end

  def test_parse_units
    file = InterestingStatementLines.new
    file.parse_units("4.0920 4.8070 6.8680 1.9180 1.3610 5.4210 2.3360 0.7120 0.6790 0.0000 0.0000 0.0000 0.0000 0.0000 0.0000")

    assert(file.units.include? 4.0920)
    assert(file.units.include? 0.6790)
    assert(file.units.include? 0)
  end

  def test_parse_units_funds
    file = InterestingStatementLines.new
    file.parse_units_funds("1 iShares Barclays 7-10 Year Treasury Bond Fund 2 iShares Barclays Aggregate Bond Fund 3 iShares Barclays TIPS Bond Fund 4 iShares Cohen & Steers Realty Majors Index Fund 5 iShares Dow Jones Select Dividend Index Fund 6 iShares MSCI EAFE Index Fund 7 iShares MSCI Emerging Markets Index Fund 8 iShares Russell 2000 Index Fund 9 SPDR DJIA Trust SPDR S&P 500 ETF Trust iShares Russell 1000 Growth Index Fund NASDAQ 100 Trust Shares iShares Russell 1000 Value Index Fund SPDR S&P MidCap 400 ETF Trust iShares Barclays 1-3 Year Treasury Bond Fund")

    assert(file.units_funds.include? "iShares Barclays 7-10 Year Treasury Bond Fund")
    assert(file.units_funds.include? "SPDR DJIA Trust")
  end
end
