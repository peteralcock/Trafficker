require 'dashing'
require 'sinatra/cross_origin'

configure do
 # set :auth_token, 'YOUR_EclecticLabs_AUTH_TOKEN'

  enable :cross_origin
  set :allow_origin, :any
  set :allow_methods, [:get, :post, :options]
  set :allow_credentials, true
  set :max_age, "1728000"
  set :expose_headers, ['Content-Type']
  set :protection, :except => :frame_options


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
