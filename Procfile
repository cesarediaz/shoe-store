websocket: websocketd --port=$WSPORT ruby inventory_stores.rb
faye: rackup faye.ru -s thin -E production
web: bundle exec ruby websocket_app.rb
redis: redis start
