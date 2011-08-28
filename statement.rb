require 'highline/import'
require 'active_support/core_ext'
require 'date'

files = Dir.glob("*-*-*.txt").map do |filename|
  file = []
  File.open(filename, "r") do |infile|
    while (line = infile.gets)
      file << line
    end
  end
  file
end

data = files.map do |file|
  bal = 0
  interesting = []
  file.each do |line|
    if bal > 0
      interesting << line
      bal += 1
      bal %= 4
    end
    if(/Ending Balance/ === line)
      bal = 1
      puts "bals"
    end
  end
  interesting
end

puts "DATA TIME"

data.each do |datum| 
  datum[2].gsub!("iShares", "XXXiShares")
  datum[2].gsub!("Vanguard", "XXXVanguard")
  datum[2].gsub!("SPDR","XXXSPDR")
  funds = datum[2].split("XXX")
  balances = datum[0].split(" ")
  puts funds.join " | "
  puts balances

#  myhash = {}
#  puts funds.zip(balances){|fund,balance| myhash[fund] = balance}
end
