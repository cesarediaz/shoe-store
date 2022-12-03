# frozen_string_literal: true

require 'sinatra/base'
require './modules/shops'

# class App API + FE
class App < Sinatra::Base
  include Shops

  configure do
    set :port, 3000
    set :db, Redis.new(reconnect_attempts: [0, 0.25, 1])
    set :views, proc { File.expand_path('../views', __dir__) }
  end

  get '/' do
    erb :index
  end

  get '/api/v1/shops' do
    shops(settings.db).to_json
  end

  get '/api/v1/shops/:key/models' do
    shop_models(settings.db, params[:key]).to_json
  end
end
