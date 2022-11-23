# frozen_string_literal: true

require './inventory'
require 'eventmachine'
require 'faye'
require 'faye/websocket'
require 'net/http'
require 'json'
require 'sinatra/base'
require 'thin'

EventMachine.run do
  class App < Sinatra::Base
    get '/' do
      erb :index
    end
  end

  ws = Faye::WebSocket::Client.new('ws://localhost:3001/')
  ws.on :open do |_event|
    p [:open]
    ws.send('connected')
  end

  ws.on :message do |event|
    p [:message, JSON.parse(event.data)]

    inventory = Inventory.new(event.data)
    alert = inventory.alert
    model = inventory.model

    broadcast(
      '/messages/new',
      store: inventory.store,
      model: model,
      quantity: inventory.inventory,
      style: alert,
      houses: inventory.shoes_transfer
    )
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end

  App.run! port: '3000'

  def broadcast(channel, msg)
    message = { channel: channel, data: msg }
    uri = URI.parse('http://localhost:9292/faye')
    Net::HTTP.post_form(uri, message: message.to_json)
  end
end
