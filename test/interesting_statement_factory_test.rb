require 'minitest/autorun'
require 'interesting_statement_factory'
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
                 "trailing grabage"]

    factory = InterestingStatementFactory.new
    interesting = Mock.new

    factory.build_interesting_statement(interesting, "date.txt", statement)

    Mock.verify(interesting).parse_date("date.txt")

    Mock.verify(interesting).parse_balances("balance")
    Mock.verify(interesting).parse_funds("funds")

    Mock.verify(interesting).parse_contributions("contributions")
    Mock.verify(interesting).parse_units("units")
    Mock.verify(interesting).parse_units_funds("units funds")
  end

  def test_build_investments
    fund_names = ["fund1", "fund2", "TOTAL"]
    stmt_stub1 = StatementStub.new(fund_names,
                                  [99.2, 25.6, 100],
                                  Date.new(2011, 2, 1),
                                  [1.1, 2.2, 3.3])
    stmt_stub2 = StatementStub.new(fund_names,
                                  [12.2, 4.6, 100],
                                  Date.new(2011, 2, 2),
                                  [1.4, 2.4, 3.8])
    investments = InterestingStatementFactory.new.build_investments [stmt_stub1,
                                                                     stmt_stub2]
    assert_equal(fund_names, investments.fund_names)
    assert_equal([Date.new(2011, 2, 1),Date.new(2011, 2, 2)],
                 investments.fund("TOTAL").dates)
  end
end

class StatementStub
  attr_reader :funds, :balances, :date, :contributions

  def initialize funds, balances, date, contributions
    @funds = funds
    @balances = balances
    @date = date
    @contributions = contributions
  end
end
