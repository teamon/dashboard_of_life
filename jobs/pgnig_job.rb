# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1d', :first_in => 0 do |job|
  send_event('pgnig', PGNiG.get!(settings.upc_login, settings.upc_password))
end
