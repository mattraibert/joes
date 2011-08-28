require 'date'

files = Dir.glob("*-*-*.txt").map do |filename|
  file = []
  File.open(filename, "r") do |infile|
    while (line = infile.gets)
      file << line
    end
  end
  [Date.parse(filename.sub(".txt","")), file]
end

data = files.map do |file|
  bal = 0
  interesting = []
  file[1].each do |line|
    if bal > 0
      interesting << line
      bal += 1
      bal %= 4
    end
    if(/Ending Balance/ === line)
      bal = 1
    end
  end
  [file[0], interesting]
end

data.each do |file|
  datum = file[1]
  datum[2].gsub!("iShares", "XXXiShares")
  datum[2].gsub!("Vanguard", "XXXVanguard")
  datum[2].gsub!("SPDR","XXXSPDR")
  datum[2].sub!("XXX","")
  
  
  funds = datum[2].split("XXX")
  funds << "TOTAL"
  balances = datum[0].split(" ")
#  puts funds.join " | "
#  puts balances

  myhash = {}
  funds.zip(balances){|fund,balance| myhash[fund] = balance}
  puts file[0]
  puts myhash
end

