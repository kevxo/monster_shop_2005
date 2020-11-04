require 'rails_helper'

describe Item, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
    it { should validate_presence_of :description }
    it { should validate_presence_of :price }
    it { should validate_presence_of :inventory }
    it { should validate_presence_of :activation_status }
    it { should validate_numericality_of(:inventory).is_greater_than(0) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end

  describe "relationships" do
    it {should belong_to :merchant}
    it {should have_many :reviews}
    it {should have_many :item_orders}
    it {should have_many(:orders).through(:item_orders)}
  end

  describe "instance methods" do
    before(:each) do

      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @tire = @bike_shop.items.create(name: "Tire", description: "For your car!", price: 75, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 2)

      @bike_shop = Merchant.create!(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @chain = @bike_shop.items.create!(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)


      @review_1 = @chain.reviews.create!(title: "Great place!", content: "They have great bike stuff and I'd recommend them to anyone.", rating: 5)
      @review_2 = @chain.reviews.create!(title: "Cool shop!", content: "They have cool bike stuff and I'd recommend them to anyone.", rating: 4)
      @review_3 = @chain.reviews.create!(title: "Meh place", content: "They have meh bike stuff and I probably won't come back", rating: 1)
      @review_4 = @chain.reviews.create!(title: "Not too impressed", content: "v basic bike shop", rating: 2)
      @review_5 = @chain.reviews.create!(title: "Okay place :/", content: "Brian's cool and all but just an okay selection of items", rating: 3)
    end

    it "calculate average review" do
      expect(@chain.average_review).to eq(3.0)
    end

    it "sorts reviews" do
      top_three = @chain.sorted_reviews(3,:desc)
      bottom_three = @chain.sorted_reviews(3,:asc)

      expect(top_three).to eq([@review_1,@review_2,@review_5])
      expect(bottom_three).to eq([@review_3,@review_4,@review_5])
    end

    it 'no orders' do
      expect(@chain.no_orders?).to eq(true)
      user_1 = User.create!(name: 'Carson', address: '123 Carson Ave.', city: 'Denver', state: 'CO', zip: 12458, email: 'carson@coolchick.com', password: 'password', role: 0)
      order = user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      order.item_orders.create!(item: @chain, price: @chain.price, quantity: 2)
      expect(@chain.no_orders?).to eq(false)
    end

    it "#quantity_purchased" do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @stress_ball = @meg.items.create!(name: "Stress Ball", description: "Squeeze the shit outta this", price: 40, image: "https://www.discountmugs.com/product-images/colors/stress014-pu-stress-ball-stress014-yellow.jpg", inventory: 191)

      @user_1 = User.create!(name: 'Carson', address: '123 Carson Ave.', city: 'Denver', state: 'CO', zip: 12458, email: 'carson@coolchick.com', password: 'password', role: 0)

      @order_1 = @user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @order_2 = @user_1.orders.create!(name: 'Kevin', address: '123 Kevin Ave', city: 'Kevin Town', state: 'FL', zip: 90909)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

      @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 15)

      expect(@pull_toy.quantity_purchased).to eq(18)
      expect(@stress_ball.quantity_purchased).to eq(0)
      expect(@tire.quantity_purchased).to_not eq(3)
    end

    it "#subtotal" do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)

      @user_1 = User.create!(name: 'Carson', address: '123 Carson Ave.', city: 'Denver', state: 'CO', zip: 12458, email: 'carson@coolchick.com', password: 'password', role: 0)

      @order_1 = @user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@tire.subtotal).to eq(200)
    end
  end

  describe 'class methods' do
    before :each do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @pull_toy = @brian.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @toothbrush = @brian.items.create!(name: "Toothbrush", description: "Clean YO Teeth", price: 29, image: "https://www.net32.com/media/shared/common/mp/dr-fresh/reach-barbie/media/reach-barbie-toothbrush-9538.jpg", inventory: 28)
      @toilet_paper = @meg.items.create!(name: "Toilet Paper", description: "Your butt will love it!", price: 21, image: "https://cdn.shopify.com/s/files/1/1320/9925/products/WGAC_ProductPhotos_2018Packaging_TransparentBG_DLSingleRoll_large.png?v=1578973373", inventory: 12)
      @candle = @meg.items.create!(name: "Candle", description: "Fresh af", price: 40, image: "https://images-na.ssl-images-amazon.com/images/I/71%2BkswJA5TL._AC_SX522_.jpg", inventory: 19)
      @advil = @meg.items.create!(name: "Advil", description: "Are you old and in pain all the time? Use this.", price: 40, image: "https://cdn.shopify.com/s/files/1/0250/1863/0241/products/11404__1487602198_1024x1024@2x.jpg?v=1599131727", inventory: 119)
      @stress_ball = @meg.items.create!(name: "Stress Ball", description: "Squeeze the shit outta this", price: 40, image: "https://www.discountmugs.com/product-images/colors/stress014-pu-stress-ball-stress014-yellow.jpg", inventory: 191)

      @user_1 = User.create!(name: 'Carson', address: '123 Carson Ave.', city: 'Denver', state: 'CO', zip: 12458, email: 'carson@coolchick.com', password: 'password', role: 0)

      @order_1 = @user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17033)
      @order_2 = @user_1.orders.create!(name: 'Kevin', address: '123 Kevin Ave', city: 'Kevin Town', state: 'FL', zip: 90909)

      @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
      @order_1.item_orders.create!(item: @toilet_paper, price: @toilet_paper.price, quantity: 8)
      @order_1.item_orders.create!(item: @candle, price: @candle.price, quantity: 35)
      @order_1.item_orders.create!(item: @toothbrush, price: @toothbrush.price, quantity: 12)

      @order_2.item_orders.create!(item: @toothbrush, price: @toothbrush.price, quantity: 11)
      @order_2.item_orders.create!(item: @advil, price: @advil.price, quantity: 1)
      @order_2.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 15)
    end
    it ".most_popular" do
      expected = [@candle, @toothbrush, @pull_toy, @toilet_paper, @tire]

      expect(Item.most_popular).to eq(expected)
    end

    it ".least_popular" do
      expected = [@advil, @tire, @toilet_paper, @pull_toy, @toothbrush]

      expect(Item.least_popular).to eq(expected)
    end
  end
end
