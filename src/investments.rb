require 'util'

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
