require 'dashing'

configure do
  set :auth_token, 'YOUR_AUTH_TOKEN'

  set :upc_login, ""
  set :upc_password, ""

  set :play_login, ""
  set :play_password, ""

  set :pgnig_login, ""
  set :pgnig_password, ""

  helpers do
    def protected!
     # Put any authentication code you want in here.
     # This method is run before accessing any resource.
    end
  end
end

map Sinatra::Application.assets_prefix do
  run Sinatra::Application.sprockets
end

run Sinatra::Application
