require 'date'
require 'data_file'

data = Dir.glob("*-*-*.txt").map do |filename|
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

fund_data = {}

data.each do |file|
  file.funds.zip(file.balances) do |fund, balance| 
    fund_data[fund] ||= {}
    fund_data[fund][file.date] = balance
  end
end

fund_data.each do |f|
  puts "#{f[0]} has data #{f[1]}\n\n" 
end




