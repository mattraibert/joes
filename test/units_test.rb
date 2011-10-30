require 'minitest/autorun'
require 'units'

class UnitsTest < MiniTest::Unit::TestCase
  def test_units
    assert_equal(Units.new(1.1), Units.new(1.1))
    assert_equal(Units.new(0.2), Units.new(4.5) - Units.new(4.3))
    assert_equal(Units.new(8.8), Units.new(4.5) + Units.new(4.3))
  end
end
