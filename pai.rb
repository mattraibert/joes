require 'mechanize'
require 'highline/import'

def get_password(prompt="Enter Password")
  ask(prompt) {|q| q.echo = false}
end

def links(page)
  page.links.each do |link|
    text = link
    puts text
  end
end

a = Mechanize.new
page = a.get("https://www.pai.com/employee/default.aspx")

page = page.form do |f| 
  f.txtUserName = "mattraibert"
  f.txtPassword = get_password()
end.click_button

page = a.click(page.link_with(:text => /My 401k/))
page = a.click(page.link_with(:text => /Statements/))

stmt = page.form do |f|
  f.field("_ctl23:_ctl1:txtFrom").value = "1/1/2007"
  f.field("_ctl23:_ctl1:txtTo").value = "1/1/2010"
end.click_button
stmt.save

