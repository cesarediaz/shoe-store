# frozen_string_literal: true

require './inventory'
require './modules/broadcast'
require './modules/shops'
require 'eventmachine'
require 'faye'
require 'faye/websocket'
require 'net/http'
require 'json'
require 'sinatra/base'

EventMachine.run do
  include Broadcast
  include Shops

  class App < Sinatra::Base
    configure do
      set :port, 3000
      set :db, Redis.new(reconnect_attempts: [0, 0.25, 1,])
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

  ws = Faye::WebSocket::Client.new('ws://localhost:3001/')
  ws.on :open do |_event|
    p [:open]
    ws.send('connected')
  end

  ws.on :message do |event|
    p [:message, JSON.parse(event.data)]

    inventory = Inventory.new(App.settings.db, event.data)
    broadcast(
      '/messages/new',
      {
        store: inventory.store,
        model: inventory.model,
        quantity: inventory.inventory,
        stock: inventory.alert,
        houses: inventory.shoes_transfer
      }
    )
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end

  App.run!
end
