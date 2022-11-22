require 'thin'
require 'sinatra/base'
require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'faye'
require 'net/http'
require './inventory'

EventMachine.run do

  class App < Sinatra::Base
    get '/' do
      erb :index
    end
  end

  ws = Faye::WebSocket::Client.new('ws://localhost:3001/')
  ws.on :open do |event|
    p [:open]
    ws.send('connected')
  end

  ws.on :message do |event|
    p [:message, JSON.parse(event.data)]
    inventory = Inventory.new(event.data)
    broadcast("/messages/new", msg: "#{inventory.store}: #{inventory.alert}")
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end


  App.run! :port => '3000'

  def broadcast(channel, msg)
    message = {:channel => channel, :data => msg}
    uri = URI.parse("http://localhost:9292/faye")
    Net::HTTP.post_form(uri, :message => message.to_json)
  end
end
