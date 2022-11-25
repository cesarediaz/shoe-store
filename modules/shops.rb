module Shops
  def shops(db)
    db.keys('ALDO*').map { |k| k.split(':')[0] }.uniq
  end

  def shop_models(db, shop)
    db.keys("#{shop}:*").map { |k| k.split(':')[1] }.uniq
  end
end
