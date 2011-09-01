require 'minitest/autorun'
require 'data_file'

class DataFileTest < MiniTest::Unit::TestCase
  def test_parse_funds
    file = DataFile.new
    file.parse_funds("SPDR DJIA Trust iShares Dow Jones Select Dividend Index Fund iShares Russell 2000 Index Fund iShares Barclays 7-10 Year Treasury Bond Fund iShares Barclays Aggregate Bond Fund iShares Barclays TIPS Bond Fund iShares Cohen & Steers Realty Majors Index Fund iShares MSCI Emerging Markets Index Fund iShares MSCI EAFE Index Fund\n")

    assert(file.funds.include? "SPDR DJIA Trust")
    assert(file.funds.include? "TOTAL")
  end

  def test_parse_balances
    file = DataFile.new
    file.parse_balances("$231.79 $246.12 $38.32 $517.14 $655.41 $651.67 $201.69 $597.55 $615.29 $3,754.98\n")

    assert(file.balances.include? "$231.79")
    assert(file.balances.include? "$3,754.98")
  end

  def test_parse_date
    file = DataFile.new
    file.parse_date("2000-06-01.txt")

    assert_equal(Date.new(2000, 6, 1), file.date)
  end
end
