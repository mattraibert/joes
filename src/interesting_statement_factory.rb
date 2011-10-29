require 'date'
require 'interesting_statement_lines'
require 'fund'
require 'util'
require 'investments'

class InterestingStatementFactory
  def read_file filename, statement, interesting = InterestingStatementLines.new
    interesting.parse_date filename
    statement.items_following(/Ending Balance/) do |lines|
      interesting.parse_balances lines[0]
      interesting.parse_funds lines[2]
    end
    statement.items_following(/Investment Option Beginning Contributions/) do |lines|
      interesting.parse_contributions lines[0]
    end
    statement.items_following(/Investment Option$/) do |lines|
      interesting.parse_units_funds lines[0]
    end
    statement.items_following(/Units/) do |lines|
      interesting.parse_units lines[0]
    end
    interesting
  end

  def extract_balances file, fund_data
    file.funds.zip(file.balances) do |fund_name, balance|
      fund_data.fund(fund_name).write_balance(file.date, balance)
    end
  end

  def extract_contributions file, fund_data
    file.funds.zip(file.contributions) do |fund_name, contribution|
      fund_data.fund(fund_name).write_contribution(file.date, contribution)
    end
  end

  def extract_units file, fund_data
    file.units_funds.zip(file.units).each do |fund_name, units|
      fund_data.fund(fund_name).write_units(file.date, units)
    end
  end

  def read_statements
    #todo allow user to specify source file directory
    Dir.glob("*-*-*.txt").map do |filename|
      file_lines = IO.read(filename).split("\n")
      read_file(filename, file_lines)
    end
  end

  def build_investments interesting_statements
    fund_data = Investments.new
    interesting_statements.each do |file|
      extract_balances file, fund_data
      extract_contributions file, fund_data
      extract_units file, fund_data
    end
    fund_data
  end

  def read_data_from_files
    build_investments read_statements
  end
end
