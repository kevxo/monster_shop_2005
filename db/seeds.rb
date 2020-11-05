# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# Merchant.destroy_all
# Item.destroy_all

#merchants
bike_shop = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
dog_shop = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

#bike_shop items
tire = bike_shop.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

#dog_shop items
pull_toy = dog_shop.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
dog_bone = dog_shop.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", activation_status:'Deactivated', inventory: 21)

admin_1 = User.create!(name: 'Mr. Peanutbutter', address: '123 Butter Ave.', city: 'Los Angeles', state: 'LA', zip: 12458, email: 'whodatdog@coolchick.com', password: 'password', role: 2)

user_1 = User.create!(name: 'Carson', address: '123 Carson Ave.', city: 'Denver', state: 'CO', zip: 12458, email: 'carson@coolchick.com', password: 'password', role: 0)

merchant_1 = User.create!(name: 'Hanna', address: '123 Hanna Ave.', city: 'Denver', state: 'CO', zip: 12453, email: 'hanna@coolchick.com', password: 'password', role: 1, merchant_id: "#{bike_shop.id}")


# @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
# @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

# @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
# @pull_toy = @brian.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
# @toothbrush = @brian.items.create!(name: "Toothbrush", description: "Clean YO Teeth", price: 29, image: "https://www.net32.com/media/shared/common/mp/dr-fresh/reach-barbie/media/reach-barbie-toothbrush-9538.jpg", inventory: 28)
# @toilet_paper = @meg.items.create!(name: "Toilet Paper", description: "Your butt will love it!", price: 21, image: "https://cdn.shopify.com/s/files/1/1320/9925/products/WGAC_ProductPhotos_2018Packaging_TransparentBG_DLSingleRoll_large.png?v=1578973373", inventory: 12)
# @candle = @meg.items.create!(name: "Candle", description: "Fresh af", price: 40, image: "https://images-na.ssl-images-amazon.com/images/I/71%2BkswJA5TL._AC_SX522_.jpg", inventory: 19)
# @advil = @meg.items.create!(name: "Advil", description: "Are you old and in pain all the time? Use this.", price: 40, image: "https://cdn.shopify.com/s/files/1/0250/1863/0241/products/11404__1487602198_1024x1024@2x.jpg?v=1599131727", inventory: 119)
# @stress_ball = @meg.items.create!(name: "Stress Ball", description: "Squeeze the shit outta this", price: 40, image: "https://www.discountmugs.com/product-images/colors/stress014-pu-stress-ball-stress014-yellow.jpg", inventory: 191)

# @order_1 = Order.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
# @order_2 = Order.create!(name: 'Kevin', address: '123 Kevin Ave', city: 'Kevin Town', state: 'FL', zip: 90909)

# @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
# @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
# @order_1.item_orders.create!(item: @toilet_paper, price: @toilet_paper.price, quantity: 8)
# @order_1.item_orders.create!(item: @candle, price: @candle.price, quantity: 35)
# @order_1.item_orders.create!(item: @toothbrush, price: @toothbrush.price, quantity: 12)

# @order_2.item_orders.create!(item: @toothbrush, price: @toothbrush.price, quantity: 11)
# @order_2.item_orders.create!(item: @advil, price: @advil.price, quantity: 1)
# @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 15)
