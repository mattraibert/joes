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

data = {}

Dir.glob("*-*-*.txt").each do |filename|
  interesting = DataFile.new
  File.open(filename, "r") do |infile|
    while (line = infile.gets)
      if(/Ending Balance/ === line)
        interesting.set_balances infile.gets
        infile.gets
        interesting.set_funds infile.gets
      end
    end
  end
  data[Date.parse(filename.sub(".txt",""))] = interesting
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




