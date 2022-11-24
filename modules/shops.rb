module Shops
  def shops
    redis = Redis.new
    redis.keys.map { |k| k.split(':')[0] }.uniq
  end

  def shop_models(shop)
    redis = Redis.new
    redis.keys("#{shop}:*").map { |k| k.split(':')[1] }.uniq
  end
end
