# :first_in sets how long it takes before the job is first run. In this case, it is run immediately
SCHEDULER.every '1d', :first_in => 0 do |job|
  send_event('play', Play.get!(settings.play_login, settings.play_password))
end
