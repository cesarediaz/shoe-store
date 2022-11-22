# frozen_string_literal: true

# Post messages to websocket channel
module Websocket
  def broadcast(channel, msg)
    message = { channel: channel, data: msg }
    uri = URI.parse('http://localhost:9292/faye')
    Net::HTTP.post_form(uri, message: message.to_json)
  end
end
