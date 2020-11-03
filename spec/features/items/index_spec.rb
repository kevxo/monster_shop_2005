require 'rails_helper'

RSpec.describe "Items Index Page" do
  describe "When I visit the items index page" do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210)

      @dog_bone = @brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", activation_status: 'Deactivated', inventory: 21)
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

    it "all items or merchant names are links" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@tire.merchant.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to have_link(@pull_toy.merchant.name)
    end

    it "I can see a list of all of the items "do

      visit '/items'

      within "#item-#{@tire.id}" do
        expect(page).to have_link(@tire.name)
        expect(page).to have_content(@tire.description)
        expect(page).to have_content("Price: $#{@tire.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@tire.inventory}")
        expect(page).to have_link(@meg.name)
        expect(page).to have_css("img[src*='#{@tire.image}']")
      end

      within "#item-#{@pull_toy.id}" do
        expect(page).to have_link(@pull_toy.name)
        expect(page).to have_content(@pull_toy.description)
        expect(page).to have_content("Price: $#{@pull_toy.price}")
        expect(page).to have_content("Active")
        expect(page).to have_content("Inventory: #{@pull_toy.inventory}")
        expect(page).to have_link(@brian.name)
        expect(page).to have_css("img[src*='#{@pull_toy.image}']")
      end
    end

    it "any user can visit the index page and see all items that are not disabled" do
      visit '/items'

      expect(page).to have_link(@tire.name)
      expect(page).to have_link(@pull_toy.name)
      expect(page).to_not have_link(@dog_bone.name)
    end

    it "any user can click on an item's image and be redirected to the item's show page" do
      visit '/items'

      find(:xpath, "//a/img[@alt='Gatorskins Image']/..").click

      expect(current_path).to eq("/items/#{@tire.id}")
    end

    it "any user sees an area with stats for 5 most popular items and 5 least popular items" do
      visit '/items'

      expect(page).to have_content("Item Statistics")

      within "#top-five-items" do
        expect(page).to have_content("Top 5 Items Purchased:")
        expect(page.all('li')[0]).to have_content("#{@candle.name}: #{@candle.quantity_purchased}")
        expect(page.all('li')[1]).to have_content("#{@toothbrush.name}: #{@toothbrush.quantity_purchased}")
        expect(page.all('li')[2]).to have_content("#{@pull_toy.name}: #{@pull_toy.quantity_purchased}")
        expect(page.all('li')[3]).to have_content("#{@toilet_paper.name}: #{@toilet_paper.quantity_purchased}")
        expect(page.all('li')[4]).to have_content("#{@tire.name}: #{@tire.quantity_purchased}")
      end

      within "#bottom-five-items" do
        expect(page).to have_content("Bottom 5 Items Purchased:")
        expect(page.all('li')[0]).to have_content("#{@advil.name}: #{@advil.quantity_purchased}")
        expect(page.all('li')[1]).to have_content("#{@tire.name}: #{@tire.quantity_purchased}")
        expect(page.all('li')[2]).to have_content("#{@toilet_paper.name}: #{@toilet_paper.quantity_purchased}")
        expect(page.all('li')[3]).to have_content("#{@pull_toy.name}: #{@pull_toy.quantity_purchased}")
        expect(page.all('li')[4]).to have_content("#{@toothbrush.name}: #{@toothbrush.quantity_purchased}")
      end
    end
  end
end
