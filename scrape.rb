require 'mechanize'
require 'highline/import'
require 'date'
require 'active_support/core_ext'

a = Mechanize.new
page = a.get("https://www.pai.com/employee/default.aspx")
user_date = Date.parse(ask("401k start date"))
user_months = ask("How many months?").to_i - 1
months = (0..user_months).map { |month| user_date + month.months }

page = page.form do |f| 
  f.txtUserName = ask("Enter Username")
  f.txtPassword = ask("Enter Password") {|q| q.echo = false}
end.click_button

page = a.click(page.link_with(:text => /My 401k/))
page = a.click(page.link_with(:text => /Statements/))

months.each do |date|
  file_name = "#{date}.pdf"

  stmt = page.form do |f|
    f.radiobutton_with(:value => /rdoManual/).check
    f.field("_ctl23:_ctl1:txtFrom").value = (date - 1.month).strftime("%-m/%-d/%Y")
    f.field("_ctl23:_ctl1:txtTo").value = date.strftime("%-m/%-d/%Y")
  end.click_button.save_as(file_name)

  `pdftotext #{file_name}`
  `rm #{file_name}`
  puts "finished #{date}"
end

