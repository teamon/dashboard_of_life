require "mechanize"

class PGNiG < Invoice
  def self.get!(*args)
    PGNiG.new(*args).get!
  end

  def initialize(login, password)
    @agent = Mechanize.new

    @login = login
    @password = password
  end

  def get!
    login
    get_data
  end

  def login
    page1 = @agent.get "https://ebok.gazownia.pl/"
    login_form = page1.forms.first
    login_form.login = @login
    login_form.passwd = @password
    login_form.submit
  end

  def get_data
    page = @agent.get "https://ebok.gazownia.pl/ajax.php?a=1&el=all"
    value = page.content.split("##").last.gsub(",", ".").to_f
    show_result(value, nil)
  end
end
