require 'units'
require 'date'
require 'active_support/core_ext'

class Fund
  attr_reader :name

  def initialize(name)
    @name = name
  end

  def write_balance(date, balance)
    @balances ||= {}
    @balances[date] = balance
  end

  def balance_for(date)
    @balances[date]
  end

  def write_contribution(date, contribution)
    @contributions ||= {}
    @contributions[date] = contribution
  end

  def contribution_for(date)
    @contributions[date]
  end

  def write_units(date, units)
    @units ||= {}
    @units[date] = Units.new(units)
  end

  def units_for(date)
    @units[date] || Units.zero
  end

  def symbol
    {"iShares Russell 1000 Growth Index Fund" => "IWF",
      "iShares Russell 1000 Value Index Fund" => "IWD",
      "iShares Russell 2000 Index Fund" => "IWM",
      "iShares Barclays TIPS Bond Fund" => "TIP",
      "Vanguard Total Bond Market ETF" => "BND",
      "Vanguard Europe Pacific ETF" => "VEA",
      "SPDR S&P 500 ETF Trust" => "SPY",
      "NASDAQ 100 Trust Shares" => "QQQ",
      "SPDR DJIA Trust" => "DIA",
      "SPDR S&P MidCap 400 ETF Trust" => "MDY",
      "iShares Dow Jones Select Dividend Index Fund" => "DVY",
      "iShares Barclays 7-10 Year Treasury Bond Fund" => "IEF",
      "iShares Barclays 1-3 Year Treasury Bond Fund" => "SHY",
      "RBB Fd Inc Money Mkt Ptf" => "BDMXX",
      "Vanguard Emerging Markets Stock ETF" => "VWO",
      "Vanguard REIT ETF" => "VNQ",
      "iShares Barclays Aggregate Bond Fund" => "BND",
      "iShares Cohen & Steers Realty Majors Index Fund" => "VNQ",
      "iShares MSCI Emerging Markets Index Fund" => "VWO",
      "iShares MSCI EAFE Index Fund" => "VEA"}[name]
  end

  def find_units_backwards(date)
    @units[date - 1.day] || units_for(@units.keys.select { |key| key < date }.last)
  end

  def delta_units_for(date)
    units_for(date) - find_units_backwards(date)
  end

  def rows
    @balances.map do |date, balance|
      "[new Date(#{date.year}, #{date.month - 1}, #{date.day}), #{balance}, undefined, undefined]"
    end.join(", ")
  end

  def dates
    @balances ||= {}
    @balances.keys
  end

  def transaction_dates
    dates.reject { |date| delta_units_for(date) == Units.zero }
  end

  def transactions
    transaction_dates.map { |date| row_for date }
  end

  def price_per_share date
    contribution_for(date) / delta_units_for(date)
  end

  def row_for(date)
    "#{name}, #{symbol}, Buy, #{date}, #{delta_units_for(date)}, #{contribution_for(date)}"
  end

  def to_s
    "Name, Symbol, Type, Date, Shares, Price<br>" + transactions.join("<br>")
  end

  def csv
    "Name, Symbol, Type, Date, Shares, Price\n" + transactions.join("\n")
  end

  def gvis
    """
<html>
  <head>
    <script type='text/javascript' src='https://www.google.com/jsapi'></script>
    <script type='text/javascript'>
      google.load('visualization', '1', {'packages':['annotatedtimeline']});
      google.setOnLoadCallback(drawChart);
      function drawChart() {
        var data = new google.visualization.DataTable();
        data.addColumn('date', 'Date');
        data.addColumn('number','#{@name}');
        data.addColumn('string', 'title1');
        data.addColumn('string', 'text1');
        data.addRows([#{rows}]);

        var chart = new google.visualization.AnnotatedTimeLine(document.getElementById('chart_div'));
        chart.draw(data, {displayAnnotations: true});
      }
    </script>
  </head>

  <body>
    <div id='chart_div' style='width: 700px; height: 240px;'></div>
    <a href='/'>List</a>
  </body>
</html>
"""
  end
end
