require "rails_helper"

RSpec.describe "Discount creation" do
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
  it "merchants can access the creation form from the discount index" do
      visit merchant_discount_path
      click_link "Create New Discount"
      expect(current_path).to eq(merchant_new_discount_path)
  end

  it "merchants can create a discount" do
    visit merchant_new_discount_path
    fill_in 'Percent', with: 5
    fill_in 'Item Quantity', with: 20
    click_on "Create Discount"
    new_discount = Discount.last
    expect(current_path).to eq(merchant_discount_path)
    expect(page).to have_content("New Discount Created")
    within "#discounts-#{new_discount.id}" do
      expect(page).to have_content("5%")
      expect(page).to have_content("20 or more items")
    end
  end

  it "merchants must fill out all fields when creating a discount" do
    visit merchant_new_discount_path
    fill_in 'Percent', with: ""
    fill_in 'Item Quantity', with: -2
    click_on "Create Discount"
    expect(page).to have_content("Percent can't be blank, Percent is not a number, and Item quantity must be greater than 0")
    expect(page).to have_button("Create Discount")
  end
end
