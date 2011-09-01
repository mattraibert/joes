class Fund
  def initialize(name)
    @name = name
  end

  def write(date, balance)
    @balances ||= {}
    @balances[date] = balance
  end

  def balance_for(date)
    @balances[date]
  end

  def to_s
    "#{@name} has data #{@balances}"
  end
end
