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
end
