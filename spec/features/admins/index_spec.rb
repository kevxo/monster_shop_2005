require 'rails_helper'

RSpec.describe 'On the admin dashboard page' do
  before :each do
    @admin_1 = User.create!(name: 'Mr. Peanutbutter',
                          address: '123 Butter Ave.',
                          city: 'Los Angeles',
                          state: 'LA',
                          zip: 12458,
                          email: 'whodatdog@coolchick.com',
                          password: 'password',
                          role: 2)

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
                            zip: 17033,
                            status: 3)
    @order_2 = @user_1.orders.create!(name: 'Kevin',
                            address: '123 Kevin Ave',
                            city: 'Kevin Town',
                            state: 'FL',
                            zip: 90909,
                            status: 0)

    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
    @toilet_paper = @meg.items.create!(name: "Toilet Paper", description: "Your butt will love it!", price: 21, image: "https://cdn.shopify.com/s/files/1/1320/9925/products/WGAC_ProductPhotos_2018Packaging_TransparentBG_DLSingleRoll_large.png?v=1578973373", inventory: 12)

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)

    @order_2.item_orders.create!(item: @toilet_paper, price: @toilet_paper.price, quantity: 3)

    visit '/login'

    fill_in :email, with: @admin_1.email
    fill_in :password, with: @admin_1.password
    click_on 'Submit'
  end
  it "I see all orders in the system" do
    visit '/admin'

    expect(page).to have_link(@user_1.name)
    expect(page).to have_content(@order_1.id)
    expect(page).to have_content(@order_2.id)
    expect(page).to have_content(@order_1.created_at.strftime("%m-%d-%Y"))
    expect(page).to have_content(@order_2.created_at.strftime("%m-%d-%Y"))

    expect("#{@order_2.id}").to appear_before("#{@order_1.id}")
  end

  it "I can ship any packaged orders and user can no longer cancel it" do
    visit '/admin'

    within "#packaged_order-#{@order_2.id}" do
      expect(page).to have_button("Ship Order")

      click_button("Ship Order")
      expect(current_path).to eq("/admin")
    end

    @order_2.reload
    expect(@order_2.status).to eq("shipped")
  end

  it "I can't ship any orders without status of packaged" do
    visit '/admin'

    within "#cancelled_order-#{@order_1.id}" do
      expect(page).to_not have_button("Ship Order")
    end
  end

  it "I can click the users nav link and am taken to admin users index page" do
    click_on "All Users"

    expect(current_path).to eq("/admin/users")
  end
end
