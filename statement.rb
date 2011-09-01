require 'date'
require 'data_file'

class Hash
  def hashmap
    self.inject({}) do |newhash, (k,v)|
      newhash[k] = yield(k, v)
      newhash
    end
  end
end

class Array
  def ziphash(values)
    hash = {}
    self.zip(values){|k,v| hash[k] = v}
    hash
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
  cnt = 0

  interesting = DataFile.new
  file.each do |line|
    if(/Ending Balance/ === line)
      cnt = 1
    end
    if(cnt == 2)
      interesting.set_balances line
    end
    if(cnt == 4)
      puts line
      interesting.set_funds line
    end
    if cnt > 0
      cnt += 1
      cnt %= 5
    end
  end
  interesting
end

data = data.hashmap do |date, file|
  hash = {}
  file.funds.zip(file.balances){|fund,balance| hash[fund] = balance}
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




