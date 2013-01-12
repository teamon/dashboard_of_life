require "mechanize"

class Play < Invoice
  def self.get!(*args)
    Play.new(*args).get!
  end

  def initialize(login, password)
    @agent = Mechanize.new

    @login = login
    @password = password
  end

  def get!
    get_data(login)
  end

  def login
    page1 = @agent.get "https://logowanie.play.pl/p4webportal/SsoRequest"
    page2 = page1.forms.first.submit
    login_form = page2.forms[1]
    login_form.login = @login
    login_form.password = @password
    login_form.random = page2.content[/jQuery.+val\('(.+)'\);/,1]
    page3 = login_form.submit
    page4 = page3.forms.first.submit
    page5 = page4.forms.first.submit
    page5.forms.first.submit
  end

  def get_data(page)
    info = "Saldo: #{"%.2f" % page.root.css(".left tr")[2].css("td span").last.text.gsub(",", ".").to_f}"
    page = @agent.get "https://24.play.pl/Play24/financeInvoicesList.htm?action=financeInvoices"
    _, value, date = page.root.css(".invoice").text.match(/(\d+,\d+).+?(\d+\.\d+\.\d+)$/).to_a
    show_result(value.gsub(",", ".").to_f, Date.parse(date), info)
  end
end
