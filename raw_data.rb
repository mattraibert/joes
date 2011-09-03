require 'date'
require 'data_file'
require 'fund'

class RawDataFactory
  def read_data_from_files
    #todo allow user to specify source file directory
    @data = Dir.glob("*-*-*.txt").map do |filename|
      interesting = DataFile.new
      File.open(filename, "r") do |infile|
        while (line = infile.gets)
          if(/Ending Balance/ === line)
            interesting.parse_date filename
            interesting.parse_balances infile.gets
            infile.gets
            interesting.parse_funds infile.gets
          end
          if(/Investment Option Beginning Contributions/ === line)
            interesting.parse_contributions infile.gets
          end
          if(/Units/ === line)
          end
        end
      end
      interesting
    end

    @fund_data = {}

    @data.each do |file|
      file.funds.zip(file.balances) do |fund, balance| 
        @fund_data[fund] ||= Fund.new fund
        @fund_data[fund].write(file.date, balance)
      end
    end

    RawData.new @fund_data
  end
end

class RawData
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
