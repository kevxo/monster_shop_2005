require "rails_helper"

RSpec.describe "Discount show" do
  before :each do
   @merchant = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
   @user = @merchant.users.create!(name: 'Grant',
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
  fill_in :email, with: @user.email
  fill_in :password, with: @user.password
  click_on 'Submit'

  @discount1 = @merchant.discounts.create(percent: 5, item_quantity: 10)
  @discount2 = @merchant.discounts.create(percent: 10, item_quantity: 20)
  @discount3 = @merchant.discounts.create(percent: 15, item_quantity: 30)
 end
  it "merchants can see percent, quantity and created_at" do
      click_link "View Bulk Discounts"
      within "#discounts-#{@discount1.id}" do
        click_link @discount1.id
      end
      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}")
      expect(page).to have_content("5%")
      expect(page).to have_content("10 or more items")
      expect(page).to have_content(@discount1.created_at)
    end

    it "show page links to edit path" do
      visit "/merchant/discounts/#{@discount1.id}"
      click_link "Edit Discount"
    end
  end
