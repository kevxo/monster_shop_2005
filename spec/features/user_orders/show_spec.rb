require 'rails_helper'

RSpec.describe 'On the user orders show page' do
  before :each do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

    @user_1 = User.create!(name: 'Carson',
                          address: '123 Carson Ave.',
                          city: 'Denver',
                          state: 'CO',
                          zip: 12458,
                          email: 'carson@coolchick.com',
                          password: 'password',
                          role: 0)
    @order_1 = @user_1.orders.create!(name: 'Meg',
                            address: '123 Stang Ave',
                            city: 'Hershey',
                            state: 'PA',
                            zip: 17033)
    @order_2 = @user_1.orders.create!(name: 'Kevin',
                            address: '123 Kevin Ave',
                            city: 'Kevin Town',
                            state: 'FL',
                            zip: 90909)

    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @toilet_paper = @meg.items.create!(name: "Toilet Paper", description: "Your butt will love it!", price: 21, image: "https://cdn.shopify.com/s/files/1/1320/9925/products/WGAC_ProductPhotos_2018Packaging_TransparentBG_DLSingleRoll_large.png?v=1578973373", inventory: 12)

    @item_order_1 = @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @item_order_2 = @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

    @order_2.item_orders.create!(item: @toilet_paper, price: @toilet_paper.price, quantity: 3)

    visit '/login'

    fill_in :email, with: @user_1.email
    fill_in :password, with: @user_1.password
    click_on 'Submit'
  end

  it "I see all info for that order" do
    visit "/profile/orders/#{@order_1.id}"

    expect(page).to have_content("Order Id #{@order_1.id}")
    expect(page).to have_content("Created On: #{@order_1.created_at.strftime("%m-%d-%Y")}")
    expect(page).to have_content("Updated On: #{@order_1.updated_at.strftime("%m-%d-%Y")}")
    expect(page).to have_content("#{@order_1.status}")

    within "#item-#{@tire.id}" do
      expect(page).to have_content(@tire.name)
      expect(page).to have_content(@tire.description)
      expect(page).to have_content("$#{@tire.price}")
      expect(page).to have_content("2")
      expect(page).to have_content("$200")
      expect(page).to have_css("img[src*='#{@tire.image}']")

    end

    within "#item-#{@pull_toy.id}" do
      expect(page).to have_content(@pull_toy.name)
      expect(page).to have_content(@pull_toy.description)
      expect(page).to have_content("$#{@pull_toy.price}")
      expect(page).to have_content("3")
      expect(page).to have_content("$30")
      expect(page).to have_css("img[src*='#{@pull_toy.image}']")
    end

    expect(page).to have_content("#{@order_1.total_quantity}")
    expect(page).to have_content("#{@order_1.grandtotal}")
  end

  it "I can cancel an order" do
    visit "/profile/orders/#{@order_1.id}"
    expect(page).to have_link("Cancel Order")

    click_link("Cancel Order")
    expect(current_path).to eq("/profile")
    expect(page).to have_content("You have successfully cancelled your order")
  end

  it "I can click on cancel order and all item orders associated are given status of 'unfulfilled' " do
    visit "/profile/orders/#{@order_1.id}"
    click_link("Cancel Order")

    expect(@item_order_1.fulfilled?).to eq(false)
    expect(@item_order_2.fulfilled?).to eq(false)
  end

  it "Order status is updated to cancelled" do
    visit "/profile/orders/#{@order_1.id}"

    click_link("Cancel Order")
    visit '/profile/orders'

    expect(page).to have_content("Order Status: cancelled")
  end
end
