require 'rails_helper'

describe Merchant, type: :model do
  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
  end

  describe 'relationships' do
    it { should have_many :items }
    it { should have_many :users }
  end

  describe 'instance methods' do
    before(:each) do
      @meg = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @tire = @meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
    end
    it 'no_orders' do
      expect(@meg.no_orders?).to eq(true)

      user_1 = User.create!(name: 'Carson', address: '123 Carson Ave.', city: 'Denver', state: 'CO', zip: 12_458, email: 'carson@coolchick.com', password: 'password', role: 0)

      order_1 = user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
      item_order_1 = order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.no_orders?).to eq(false)
    end

    it 'item_count' do
      chain = @meg.items.create(name: 'Chain', description: "It'll never break!", price: 30, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)

      expect(@meg.item_count).to eq(2)
    end

    it 'average_item_price' do
      chain = @meg.items.create(name: 'Chain', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)

      expect(@meg.average_item_price).to eq(70)
    end

    it 'distinct_cities' do
      chain = @meg.items.create(name: 'Chain', description: "It'll never break!", price: 40, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 22)
      user_1 = User.create!(name: 'Carson', address: '123 Carson Ave.', city: 'Denver', state: 'CO', zip: 12_458, email: 'carson@coolchick.com', password: 'password', role: 0)
      order_1 = user_1.orders.create!(name: 'Meg', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033)
      order_2 = user_1.orders.create!(name: 'Brian', address: '123 Brian Ave', city: 'Denver', state: 'CO', zip: 17_033)
      order_3 = user_1.orders.create!(name: 'Dao', address: '123 Mike Ave', city: 'Denver', state: 'CO', zip: 17_033)
      order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
      order_2.item_orders.create!(item: chain, price: chain.price, quantity: 2)
      order_3.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)

      expect(@meg.distinct_cities).to include('Denver')
      expect(@meg.distinct_cities).to include('Hershey')
    end

    it 'deactivate_all_items' do
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 0)

      meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      toilet_paper = meg.items.create!(name: 'Toilet Paper', description: 'Your butt will love it!', price: 21, image: 'https://cdn.shopify.com/s/files/1/1320/9925/products/WGAC_ProductPhotos_2018Packaging_TransparentBG_DLSingleRoll_large.png?v=1578973373', inventory: 12)
      order_1 = user_1.orders.create!(name: 'Matt', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, status: 'pending')
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
      item_order_2 = order_1.item_orders.create!(item: toilet_paper, price: toilet_paper.price, quantity: 1)

      meg.update(status: "Deactivated")
      meg.deactivate_items

      expect(tire.activation_status).to eq('Deactivated')
      expect(toilet_paper.activation_status).to eq('Deactivated')
    end

    it 'activate_all_items' do
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 0)

      meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203, status: 'Disabled')
      tire = meg.items.create(name: 'Gatorskins', description: "They'll never pop!", price: 100, image: 'https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588', inventory: 12)
      toilet_paper = meg.items.create!(name: 'Toilet Paper', description: 'Your butt will love it!', price: 21, image: 'https://cdn.shopify.com/s/files/1/1320/9925/products/WGAC_ProductPhotos_2018Packaging_TransparentBG_DLSingleRoll_large.png?v=1578973373', inventory: 12)
      order_1 = user_1.orders.create!(name: 'Matt', address: '123 Stang Ave', city: 'Hershey', state: 'PA', zip: 17_033, status: 'pending')
      item_order_1 = order_1.item_orders.create!(item: tire, price: tire.price, quantity: 2)
      item_order_2 = order_1.item_orders.create!(item: toilet_paper, price: toilet_paper.price, quantity: 1)

      meg.deactivate_items
      meg.update(status: "Activated")
      meg.activate_items

      expect(tire.activation_status).to eq('Activated')
      expect(toilet_paper.activation_status).to eq('Activated')
    end
  end
end
