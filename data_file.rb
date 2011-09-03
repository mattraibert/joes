require 'date'
require 'bigdecimal'

def money_string_to_float money_string
  money_string.gsub(/\$|,/,"").to_f
end

class DataFile
  attr_reader :balances, :funds, :date, :contributions
  
  def parse_funds funds_line
    funds_line.strip
    funds_line.gsub!("iShares", "XXXiShares")
    funds_line.gsub!("Vanguard", "XXXVanguard")
    funds_line.gsub!("SPDR","XXXSPDR")
    funds_line.sub!("XXX","")
    @funds = funds_line.split("XXX").map {|f| f.strip }
    @funds << "TOTAL"
  end

  def parse_balances balances_line
    @balances = balances_line.split(" ").map{|dstring| money_string_to_float(dstring) }
  end

  def parse_date filename
    @date = Date.parse(filename.sub(".txt",""))
  end

  def parse_contributions contributions_line
    first = @funds.size
    last = first + funds.size - 1
    @contributions = contributions_line.split(" ")[first..last]
    @contributions = @contributions.map{|dstring| money_string_to_float(dstring) }
  end
end
