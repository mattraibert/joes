require 'date'
require 'interesting_statement_lines'
require 'fund'
require 'util'
require 'investments'

class InterestingStatementFactory
  def build_interesting_statement interesting, filename, stmt
    interesting.parse_date filename
    stmt.items_following(/Ending Balance/) do |lines|
      interesting.parse_balances lines[0]
      interesting.parse_funds lines[2]
    end
    stmt.items_following(/Investment Option Beginning Contributions/) do |lines|
      interesting.parse_contributions lines[0]
    end
    stmt.items_following(/Investment Option$/) do |lines|
      interesting.parse_units_funds lines[0]
    end
    stmt.items_following(/Units/) do |lines|
      interesting.parse_units lines[0]
    end
    interesting
  end

  def build_investments interesting_statements
    fund_data = {}
    interesting_statements.each do |file|
      file.funds.zip(file.balances) do |fund, balance|
        fund_data[fund] ||= Fund.new fund
        fund_data[fund].write_balance(file.date, balance)
      end
      file.funds.zip(file.contributions) do |fund, contribution|
        fund_data[fund] ||= Fund.new fund
        fund_data[fund].write_contribution(file.date, contribution)
      end
    end

    Investments.new fund_data
  end

  def read_data_from_files
    #todo allow user to specify source file directory
    data = Dir.glob("*-*-*.txt").map do |filename|
      file_lines = IO.read(filename).split("\n")
      interesting = InterestingStatementLines.new
      build_interesting_statement(interesting, filename, file_lines)
    end
    build_investments data
  end
end
