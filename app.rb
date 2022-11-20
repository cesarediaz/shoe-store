require 'thin'
require 'sinatra/base'
require 'faye/websocket'
require 'eventmachine'
require 'json'

EventMachine.run do
  class App < Sinatra::Base
    get '/' do
      erb :index
    end
  end

  ws = Faye::WebSocket::Client.new('ws://localhost:3001/')
  ws.on :open do |event|
    p [:open]
    ws.send('Hello, world!')
  end

  ws.on :message do |event|
    p [:message, JSON.parse(event.data)]
  end

  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end

  App.run! :port => '3000'
end
