require 'date'

class DataFile
  attr_reader :balances, :funds
  
  def set_funds funds_line
    funds_line.strip
    funds_line.gsub!("iShares", "XXXiShares")
    funds_line.gsub!("Vanguard", "XXXVanguard")
    funds_line.gsub!("SPDR","XXXSPDR")
    funds_line.sub!("XXX","")
    @funds = funds_line.split("XXX").map {|f| f.strip }
    @funds << "TOTAL"
  end

  def set_balances balances_line
    @balances = balances_line.split(" ")
  end
end
