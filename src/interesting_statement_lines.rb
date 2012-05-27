require 'date'
require 'bigdecimal'

def convert_money_line(money_line)
  money_line.split(" ").map { |money_string| money_string.gsub(/\$|,/, "").to_f }
end

class InterestingStatementLines
  attr_reader :balances, :funds, :date, :contributions, :units, :units_funds

  def parse_funds(funds_line)
    @funds = split_funds funds_line
    @funds << "TOTAL"
  end

  def split_funds(funds_line)
    funds_line.strip
    funds_line.gsub!("iShares", "XXXiShares")
    funds_line.gsub!("Vanguard", "XXXVanguard")
    funds_line.gsub!("SPDR", "XXXSPDR")
    funds_line.sub!("XXX", "")
    funds_line.split("XXX").map { |f| f.strip }
  end

  def parse_balances(balances_line)
    @balances = convert_money_line balances_line
  end

  def parse_date(filename)
    @date = Date.parse(filename.sub(".txt", ""))
  end

  def parse_contributions(contributions_line)
    @contributions = convert_money_line contributions_line
    first = @contributions.size / 3
    last = 2 * first - 1
    @contributions = @contributions[first..last]
  end

  def parse_units_funds(line)
    @units_funds = split_funds line.gsub(/(^| )\d\d? /, " ")
  end

  def parse_units(line)
    @units = line.split(" ").map { |unit| unit.to_f }
  end
end
