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
  end
end
