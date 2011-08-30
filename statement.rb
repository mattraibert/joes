require 'date'

class Hash
  def hashmap
    self.inject({}) do |newhash, (k,v)|
      newhash[k] = yield(k, v)
      newhash
    end
  end
end

files = {}

Dir.glob("*-*-*.txt").each do |filename|
  file = []
  File.open(filename, "r") do |infile|
    while (line = infile.gets)
      file << line
    end
  end
  files[Date.parse(filename.sub(".txt",""))] = file
end

data = files.hashmap do |date, file|
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
    end
  end
  interesting
end

class Array
  def ziphash(values)
    hash = {}
    self.zip(values){|k,v| hash[k] = v}
    hash
  end
end

data = data.hashmap do |date, file|
  datum = file
  datum[2].strip
  datum[2].gsub!("iShares", "XXXiShares")
  datum[2].gsub!("Vanguard", "XXXVanguard")
  datum[2].gsub!("SPDR","XXXSPDR")
  datum[2].sub!("XXX","")
  funds = datum[2].split("XXX")
  funds << "TOTAL"
  balances = datum[0].split(" ")

  hash = {}
  funds.zip(balances){|fund,balance| hash[fund.strip] = balance}
  hash
end

fund_data = {}

data.each do |d|
  date = d[0]
  balances = d[1]

  balances.each do |b|
    fund = b[0]
    balance = b[1]
    fund_data[fund] ||= {}
    fund_data[fund][date.strftime("%-m/%-d/%Y")] = balance
  end
end

fund_data.each do |f|
  puts "#{f[0]} has data #{f[1]}\n\n" 
end




