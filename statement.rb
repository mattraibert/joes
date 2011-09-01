require 'date'
require 'data_file'

data = Dir.glob("*-*-*.txt").map do |filename|
  interesting = DataFile.new
  File.open(filename, "r") do |infile|
    while (line = infile.gets)
      if(/Ending Balance/ === line)
        interesting.set_balances infile.gets
        infile.gets
        interesting.set_funds infile.gets
        interesting.set_date filename
      end
    end
  end
  interesting
end

fund_data = {}

data.each do |file|
  file.funds.zip(file.balances) do |fund,balance| 
    fund_data[fund] ||= {}
    fund_data[fund][file.date.strftime("%-m/%-d/%Y")] = balance
  end
end

fund_data.each do |f|
  puts "#{f[0]} has data #{f[1]}\n\n" 
end




