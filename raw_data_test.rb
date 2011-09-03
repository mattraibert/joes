require 'minitest/autorun'
require 'raw_data'
require 'date'
require 'active_support/core_ext'

class RawDataTest < MiniTest::Unit::TestCase
  def test_csv
    expected_csv = ["Date, iShares Raibert Fund, ANOTHER Fund, TOTAL",
     "2008-01-01, 50000, 40000, 90000",
     "2008-01-02, 50001, 40001, 90002"].join("\n")
    
    irf = Fund.new("iShares Raibert Fund")
    irf.write(Date.parse("2008-01-01"), 50000)
    irf.write(Date.parse("2008-01-02"), 50001)

    af = Fund.new("ANOTHER Fund")
    af.write(Date.parse("2008-01-01"), 40000)
    af.write(Date.parse("2008-01-02"), 40001)

    total = Fund.new("TOTAL")
    total.write(Date.parse("2008-01-01"), 90000)
    total.write(Date.parse("2008-01-02"), 90002)

    rd = RawData.new({
      "iShares Raibert Fund" => irf, 
      "ANOTHER Fund" => af,
      "TOTAL" => total
    })

    assert_equal(expected_csv, rd.csv)
  end
end
