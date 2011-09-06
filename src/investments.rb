require 'date'
require 'interesting_statement_lines'
require 'fund'
require 'util'

class InterestingStatementFactory
  def build_interesting_statement filename, stmt
    interesting = InterestingStatementLines.new
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

  def read_data_from_files
    #todo allow user to specify source file directory
    @data = Dir.glob("*-*-*.txt").map do |filename|
      build_interesting_statement filename, IO.read(filename).split("\n")
    end

    @fund_data = {}

    @data.each do |file|
      file.funds.zip(file.balances) do |fund, balance| 
        @fund_data[fund] ||= Fund.new fund
        @fund_data[fund].write_balance(file.date, balance)
      end
      file.funds.zip(file.contributions) do |fund, contribution| 
        @fund_data[fund] ||= Fund.new fund
        @fund_data[fund].write_contribution(file.date, contribution)
      end
    end

    Investments.new @fund_data
  end
end

class Investments
  def initialize fund_data
    @fund_data = fund_data
  end

  def fund(name)
    @fund_data[name]
  end

  def fund_names
    @fund_data.keys
  end

  def csv
    csv = [(["Date"] + fund_names).join(', ')]
    csv += fund("TOTAL").dates.map do |date|
      ([date] + fund_names.map {|name| fund(name).balance_for(date) }).join(', ')
    end
    csv.join("\n")
  end
end
