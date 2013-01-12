require "mechanize"

class UPC < Invoice
  def self.get!(*args)
    UPC.new(*args).get!
  end

  def initialize(login, password)
    @agent = Mechanize.new

    @login = login
    @password = password
  end

  def get!
    get_data(get_session_id)
  end

  def get_session_id
    page1 = @agent.get "https://ebok.upc.pl/"
    login_form = page1.forms.first
    login_form._58_login = @login
    login_form._58_password = @password
    page2 = login_form.submit

    page2.content[/sessionID=(.+?)'/, 1]
  end

  def get_data(session_id)
    url = "https://ebok.upc.pl/upc-eBok-invoice-0/WSFlexServiceBean"

    headers = {
      "Content-type" => "text/xml; charset=utf-8",
      "SOAPAction" =>  ""
    }

    body = <<-EOS
      <SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
        <SOAP-ENV:Body>
          <tns:getClientData xmlns:tns="http://ebok.service">
            <tns:sessionid>#{session_id}</tns:sessionid>
          </tns:getClientData>
        </SOAP-ENV:Body>
      </SOAP-ENV:Envelope>
    EOS

    file = @agent.post(url, body, headers)

    doc = Nokogiri::XML(file.content)
    doc.remove_namespaces!
    label = doc.css("currentBalanceDescription2").text

    show_result(label[/faktury ([\d.]+)/, 1].to_f, Date.parse(label[/(\d+\/\d+\/\d+$)/, 1]))
  end
end
