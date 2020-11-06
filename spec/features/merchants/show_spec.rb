require 'rails_helper'

RSpec.describe 'merchant show page', type: :feature do
  describe 'As a user' do
    before :each do
      @bike_shop = Merchant.create(name: "Brian's Bike Shop", address: '123 Bike Rd.', city: 'Richmond', state: 'VA', zip: 23137)
    end

    it 'I can see a merchants name, address, city, state, zip' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_content("Brian's Bike Shop")
      expect(page).to have_content("123 Bike Rd.\nRichmond, VA 23137")
    end

    it 'I can see a link to visit the merchant items' do
      visit "/merchants/#{@bike_shop.id}"

      expect(page).to have_link("All #{@bike_shop.name} Items")

      click_on "All #{@bike_shop.name} Items"

      expect(current_path).to eq("/merchants/#{@bike_shop.id}/items")
    end
  end
  describe "As a merchant" do
    it "Merchant sees an order show page with only the items bought from that merchant including the items name(which is a link to item's show page), image, price, and quantity the user wants to purchase" do
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
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
      item_order_2 = order_1.item_orders.create!(item: toilet_paper, price: toilet_paper.price, quantity: 1)

      visit '/'

      click_link 'Log In'

      expect(current_path).to eq('/login')

      fill_in :email, with: user_1.email
      fill_in :password, with: user_1.password

      click_on 'Submit'

      visit '/merchant'

      click_link "Order #{order_1.id}"

      expect(current_path).to eq("/merchant/orders/#{order_1.id}")
      expect(page).to have_link(tire.name)
      expect(page).to have_content(tire.image)
      expect(page).to have_content(tire.price)
      expect(page).to have_content(item_order_1.quantity)

      expect(page).to have_link(toilet_paper.name)
      expect(page).to have_content(toilet_paper.image)
      expect(page).to have_content(toilet_paper.price)
      expect(page).to have_content(item_order_2.quantity)
    end
  end
    it "Merchant fulfills part of an order" do
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
        item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
        item_order_2 = order_1.item_orders.create!(item: toilet_paper, price: toilet_paper.price, quantity: 1)

        visit '/'

        click_link 'Log In'

        expect(current_path).to eq('/login')

        fill_in :email, with: user_1.email
        fill_in :password, with: user_1.password

        click_on 'Submit'

        visit '/merchant'

        click_link "Order #{order_1.id}"

        within "#item-#{tire.id}" do
          click_link "fulfill"
        end

        tire.reload
        expect(current_path).to eq("/merchant/orders/#{order_1.id}")
        expect(page).to have_content("#{item_order_1.id} has been fulfilled.")

        expect(tire.inventory).to eq(10)
    end
    it "Merchant fulfills part of an order" do
        meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        user_1 = meg.users.create!(name: 'Grant',
                                   address: '124 Grant Ave.',
                                   city: 'Denver',
                                   state: 'CO',
                                   zip: 12_345,
                                   email: 'grant@coolguy.com',
                                   password: 'password',
                                   role: 1)

        tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 1)
        toilet_paper = meg.items.create!(name: "Toilet Paper", description: "Your butt will love it!", price: 21, image: "https://cdn.shopify.com/s/files/1/1320/9925/products/WGAC_ProductPhotos_2018Packaging_TransparentBG_DLSingleRoll_large.png?v=1578973373", inventory: 10)
        order_1 = user_1.orders.create!(name: 'Matt', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
        item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
        item_order_2 = order_1.item_orders.create!(item: toilet_paper, price: toilet_paper.price, quantity: 1)

        visit '/'

        click_link 'Log In'

        expect(current_path).to eq('/login')

        fill_in :email, with: user_1.email
        fill_in :password, with: user_1.password

        click_on 'Submit'

        visit '/merchant'

        click_link "Order #{order_1.id}"

        within "#item-#{tire.id}" do
          expect(page).to have_content("#{item_order_1.item.name} not in stock for that quantity.")
        end
      end
    end
