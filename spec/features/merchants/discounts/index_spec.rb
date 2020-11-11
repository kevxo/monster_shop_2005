require "rails_helper"

RSpec.describe "Discount Index" do
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
  it "merchants can see all discounts percent and quantity" do

      click_link "View Bulk Discounts"

      within "#discounts-#{@discount1.id}" do
        expect(page).to have_content("5%")
        expect(page).to have_content("10 or more items")
      end
      within "#discounts-#{@discount2.id}" do
        expect(page).to have_content("10%")
        expect(page).to have_content("20 or more items")
      end
      within "#discounts-#{@discount3.id}" do
        expect(page).to have_content("15%")
        expect(page).to have_content("30 or more items")
      end
    end

    it "discount id links to discount show page" do
      click_link "View Bulk Discounts"

      within "#discounts-#{@discount1.id}" do
        click_link @discount1.id
      end
      expect(current_path).to eq("/merchant/discounts/#{@discount1.id}")
    end
end
