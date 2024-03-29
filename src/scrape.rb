require 'mechanize'
require 'highline/import'
require 'date'
require 'active_support/core_ext'

a = Mechanize.new
page = a.get("https://www.pai.com/employee/default.aspx")
user_date = Date.parse(ask("401k start date"))
user_granularity = ask("What granularity? (days, weeks, months, years)")
how_many_data_points = ask("How many #{user_granularity}?").to_i - 1
dates = (0..how_many_data_points).map { |count| user_date + count.send(user_granularity) }

page = page.form do |f| 
  f.txtUserName = ask("Enter Username")
  f.txtPassword = ask("Enter Password") {|q| q.echo = false}
end.click_button

page = a.click(page.link_with(:text => /My 401k/))
page = a.click(page.link_with(:text => /Statements/))

dates.each do |date|
  file_name = "#{date}.pdf"

  stmt = page.form do |f|
    f.radiobutton_with(:value => /rdoManual/).check
    f.field("_ctl23:_ctl1:txtFrom").value = (date - 1.send(user_granularity)).strftime("%-m/%-d/%Y")
    f.field("_ctl23:_ctl1:txtTo").value = date.strftime("%-m/%-d/%Y")
  end.click_button.save_as(file_name)

  `pdftotext #{file_name}`
  `rm #{file_name}`
  puts "finished #{date}"
end

