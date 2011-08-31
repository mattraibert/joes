require 'minitest/autorun'
require 'data_file'

class StatementTest < MiniTest::Unit::TestCase
  def test_data_file_set_funds
    file = DataFile.new
    file.set_funds("SPDR DJIA Trust iShares Dow Jones Select Dividend Index Fund iShares Russell 2000 Index Fund iShares Barclays 7-10 Year Treasury Bond Fund iShares Barclays Aggregate Bond Fund iShares Barclays TIPS Bond Fund iShares Cohen & Steers Realty Majors Index Fund iShares MSCI Emerging Markets Index Fund iShares MSCI EAFE Index Fund\n")

    assert(file.funds.include? "SPDR DJIA Trust")
    assert(file.funds.include? "TOTAL")
  end

  def test_data_file_set_balances
    file = DataFile.new
    file.set_balances("$231.79 $246.12 $38.32 $517.14 $655.41 $651.67 $201.69 $597.55 $615.29 $3,754.98\n")

    assert(file.balances.include? "$231.79")
    assert(file.balances.include? "$3,754.98")
  end
end
