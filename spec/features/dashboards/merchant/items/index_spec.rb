require 'rails_helper'

RSpec.describe 'As a merchant employee' do
  describe "When I visit my merchant dashboard ('/merchant')" do
    it 'I see a link to view my own items' do
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

      expect(page).to have_link("My Items")

      click_link "My Items"

      expect(current_path).to eq("/merchant/items")
    end

    describe "As an admin user" do
      it "When I visit the merchant index page and click on a merchant name URI should be /admin/merchants/id and see what a merchant would see" do
        meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        user_1 = meg.users.create!(name: 'Grant',
                                   address: '124 Grant Ave.',
                                   city: 'Denver',
                                   state: 'CO',
                                   zip: 12_345,
                                   email: 'grant@coolguy.com',
                                   password: 'password',
                                   role: 2)
        visit '/'

        click_link 'Log In'

        expect(current_path).to eq('/login')

        fill_in :email, with: user_1.email
        fill_in :password, with: user_1.password

        click_on 'Submit'

        visit '/merchants'

        click_link "Meg's Bike Shop"

        expect(current_path).to eq("/admin/merchants/#{meg.id}")
      end
    end
  end
end
