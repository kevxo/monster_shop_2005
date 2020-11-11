require "rails_helper"

RSpec.describe "Discount edit" do
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

  @discount = @merchant.discounts.create(percent: 5, item_quantity: 10)
 end
  it "merchants can edit a discounts price and item_quantity" do
      visit merchant_edit_discount_path(@discount.id)
      fill_in 'Percent', with: 10
      fill_in 'Item Quantity', with: 20
      click_on "Update Discount"
      expect(current_path).to eq(merchant_discount_path)
      expect(page).to have_content("Discount Edited")
      within "#discounts-#{@discount.id}" do
        expect(page).to have_content("10%")
        expect(page).to have_content("20 or more items")
      end
  end
  it "merchants must fill out all fields" do
      visit "/merchant/discounts/#{@discount.id}/edit"
      fill_in 'Percent', with: -1
      click_on "Update Discount"
      expect(page).to have_content("Percent must be greater than 0")
      expect(page).to have_button("Update Discount")
  end
end
