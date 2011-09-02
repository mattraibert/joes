require 'date'
require 'data_file'
require 'fund'

class RawData
  def initialize
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
  end

  def fund(name)
    @fund_data[name]
  end

  def fund_names
    @fund_data.keys
  end
end