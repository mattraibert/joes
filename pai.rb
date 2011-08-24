require 'mechanize'
require 'highline/import'

def get_password(prompt="Enter Password")
  ask(prompt) {|q| q.echo = false}
end

a = Mechanize.new


def links(page)
  page.links.each do |link|
    text = link
    puts text
  end
end

login_page = a.get("https://www.pai.com/employee/default.aspx")

my_page = login_page.form do |f| 
  f.txtUserName = "mattraibert"
  #pw = get_password()
  f.txtPassword = 'suiluj21'
end.click_button

my_401k = a.click(my_page.link_with(:text => /My 401k/))
statements = a.click(my_401k.link_with(:text => /Statements/))

stmt = statements.form do |f|
  f.field("_ctl23:_ctl1:txtFrom").value = "1/1/2007"
  f.field("_ctl23:_ctl1:txtTo").value = "1/1/2010"
end.click_button
stmt.save

