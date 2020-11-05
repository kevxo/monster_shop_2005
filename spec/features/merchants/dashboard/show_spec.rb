require 'rails_helper'

RSpec.describe 'As a merchant employee' do
  describe "When I visit my merchant dashboard ('/merchant')" do
    it 'should see the name and full address of the merchant I work for.' do
      meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      user_1 = meg.users.create!(name: 'Grant',
                                 address: '124 Grant Ave.',
                                 city: 'Denver',
                                 state: 'CO',
                                 zip: 12_345,
                                 email: 'grant@coolguy.com',
                                 password: 'password',
                                 role: 1)
      visit '/'

      click_link 'Log In'

      expect(current_path).to eq('/login')

      fill_in :email, with: user_1.email
      fill_in :password, with: user_1.password

      click_on 'Submit'

      visit '/merchant'

      expect(page).to have_content(meg.name)
      expect(page).to have_content(meg.address)
      expect(page).to have_content(meg.city)
      expect(page).to have_content(meg.state)
      expect(page).to have_content(meg.zip)
    end

    it 'if status is pending user should see that orders info' do
      meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      user_1 = meg.users.create!(name: 'Grant',
                                 address: '124 Grant Ave.',
                                 city: 'Denver',
                                 state: 'CO',
                                 zip: 12_345,
                                 email: 'grant@coolguy.com',
                                 password: 'password',
                                 role: 1)

      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      toilet_paper = meg.items.create!(name: "Toilet Paper", description: "Your butt will love it!", price: 21, image: "https://cdn.shopify.com/s/files/1/1320/9925/products/WGAC_ProductPhotos_2018Packaging_TransparentBG_DLSingleRoll_large.png?v=1578973373", inventory: 12)
      order_1 = user_1.orders.create!(name: 'Matt', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
      order_2 = user_1.orders.create!(name: 'John', address: '126 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, status: 2)
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
      item_order_2 = order_1.item_orders.create!(item: toilet_paper, price: toilet_paper.price, quantity: 1)
      item_order_3 = order_2.item_orders.create!(item: tire, price: tire.price, quantity: 3)
      item_order_4 = order_2.item_orders.create!(item: toilet_paper, price: toilet_paper.price, quantity: 1)

      visit '/'

      click_link 'Log In'

      expect(current_path).to eq('/login')

      fill_in :email, with: user_1.email
      fill_in :password, with: user_1.password

      click_on 'Submit'

      visit '/merchant'
      within "#order-info-#{order_1.id}" do
        expect(page).to have_link("Order #{order_1.id}")
        expect(page).to have_content("Created order on: #{meg.created_at}")
        expect(page).to have_content("Total Quantity: #{order_1.total_quantity}")
        expect(page).to have_content("Total Value: $#{order_1.grandtotal}")
      end

      within "#order-info-#{order_2.id}" do
        expect(page).to_not have_link("Order #{order_2.id}")
        expect(page).to_not have_content("Created order on: #{meg.created_at}")
        expect(page).to_not have_content("Total Quantity: #{order_2.total_quantity}")
        expect(page).to_not have_content("Total Value: $#{order_2.grandtotal}")
      end
    end
  end
end
