class Fund
  attr_reader :name

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

  def rows
    @balances.map do |date, balance|
      "[new Date(#{date.strftime("%Y, %-m, %e")}), #{balance}, undefined, undefined]"
    end.join(", ")
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
