module Shops
  def shops
    redis = Redis.new
    redis.keys.map { |k| k.split(':')[0] }.uniq
  end
end
