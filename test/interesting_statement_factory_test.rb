require 'minitest/autorun'
require '../src/interesting_statement_factory'
require 'grasshopper'

class InterestingStatementFactoryTest < MiniTest::Unit::TestCase
  def test_can_extract_the_right_lines_from_a_statement
    statement = ["beginning garbage",
      "Investment Option Beginning Contributions",
      "contributions",
      "some garbage",
      "Units",
      "units",
      "blah blah",
      "Investment Option",
      "units funds",
      "garbage",
      "Ending Balance",
      "balance",
      "blank",
      "funds",
      "trailing garbage"]

    factory = InterestingStatementFactory.new
    interesting = factory.read_file("date.txt", statement, Mock.new)

    Mock.verify(interesting).parse_date("date.txt")
    Mock.verify(interesting).parse_balances("balance")
    Mock.verify(interesting).parse_funds("funds")
    Mock.verify(interesting).parse_contributions("contributions")
    Mock.verify(interesting).parse_units("units")
    Mock.verify(interesting).parse_units_funds("units funds")
  end

  def test_build_investments
    fund_names = %w(fund1 fund2 TOTAL)
    stmt_stub1 = StatementStub.new(fund_names, [99.2, 25.6, 100], [1.1, 2.2, 3.3], [], [], Date.new(2011, 2, 1))
    stmt_stub2 = StatementStub.new(fund_names, [12.2, 4.6, 100], [1.4, 2.4, 3.8], [], [], Date.new(2011, 2, 2))

    investments = InterestingStatementFactory.new.build_investments [stmt_stub1, stmt_stub2]

    assert_equal(fund_names, investments.fund_names)
    assert_equal([Date.new(2011, 2, 1),Date.new(2011, 2, 2)], investments.fund("TOTAL").dates)
  end

  def test_build_units
    date = Date.new(2011, 2, 2)
    stmt_stub1 = StatementStub.new([], [], [], ["fund1", "fund2", "matts fund"], [4.336, 2.9, 0.00], date)
    stmt_stub2 = StatementStub.new([], [], [], ["fund1", "fund2", "matts fund"], [4.9, 3.1, 0.00], date + 1.month)

    investments = InterestingStatementFactory.new.build_investments [stmt_stub1, stmt_stub2]

    assert_equal(Units.new(4.336), investments.fund("fund1").units_for(date))
  end
end

class StatementStub
  attr_reader :funds, :balances, :date, :contributions, :units_funds, :units

  def initialize(funds, balances, contributions, units_funds, units, date)
    @funds = funds
    @balances = balances
    @date = date
    @contributions = contributions
    @units_funds = units_funds
    @units = units
  end
end
