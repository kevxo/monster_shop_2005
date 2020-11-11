require 'rails_helper'

RSpec.describe "Cart discounts" do
  describe "As a user" do
    before :each do
      @megan = Merchant.create!(name: 'Megans Marmalades', address: '123 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @brian = Merchant.create!(name: 'Brians Bagels', address: '125 Main St', city: 'Denver', state: 'CO', zip: 80218)
      @user = @megan.users.create!(name: 'Grant',
                                 address: '124 Grant Ave.',
                                 city: 'Denver',
                                 state: 'CO',
                                 zip: 12345,
                                 email: 'grant@coolguy.com',
                                 password: 'password',
                                 role: 1)
      visit '/'
      click_link 'Log In'
      expect(current_path).to eq('/login')
      fill_in :email, with: @user.email
      fill_in :password, with: @user.password
      click_on 'Submit'
      @ogre = @megan.items.create!(name: 'Ogre', description: "I'm an Ogre!", price: 20, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', activation_status: true, inventory: 15 )
      @giant = @megan.items.create!(name: 'Giant', description: "I'm a Giant!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', activation_status: true, inventory: 3 )
      @hippo = @brian.items.create!(name: 'Hippo', description: "I'm a Hippo!", price: 50, image: 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTaLM_vbg2Rh-mZ-B4t-RSU9AmSfEEq_SN9xPP_qrA2I6Ftq_D9Qw', activation_status: true, inventory: 3 )
      @megan.discounts.create(percent: 5, item_quantity: 10)
      @megan.discounts.create(percent: 7, item_quantity: 15)
      @megan.discounts.create(percent: 10, item_quantity: 20)
    end

    it "Cart price shows merchant discounts" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/items/#{@ogre.id}"
      click_button 'Add To Cart'
      visit "/items/#{@hippo.id}"
      click_button 'Add To Cart'
      visit '/cart'
      within "#cart-item-#{@ogre.id}" do
        expect(page).to have_content("$20.00")
        fill_in "quantity", with: 10
        click_on 'Quantity +'
        expect(page).to have_content("Discounted Subtotal: $209.00")
      end
      expect(page).to have_content("Total: $259.00")
    end

    it "order_item price is effected by discount" do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "/items/#{@ogre.id}"
      click_button 'Add To Cart'
      visit '/cart'
      within "#cart-item-#{@ogre.id}" do
        fill_in "quantity", with: 10
        click_on 'Quantity +'
      end
      click_link 'Checkout'

      fill_in :name, with: "Grant"
      fill_in :address, with: "123 Shirley St."
      fill_in :city, with: "Denver"
      fill_in :state, with: "CO"
      fill_in :zip, with: 80022

      click_on "Create Order"

      item_order = ItemOrder.last

      expect(item_order.price).to eq(19)
    end
  end
end
