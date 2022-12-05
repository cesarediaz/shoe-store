# frozen_string_literal: true

require './models/inventory'
require './modules/broadcast'
require './web/app'
require 'eventmachine'
require 'faye'
require 'faye/websocket'
require 'net/http'
require 'json'

EventMachine.run do
  include Broadcast

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
