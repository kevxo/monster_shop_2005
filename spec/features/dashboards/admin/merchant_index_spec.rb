require 'rails_helper'

RSpec.describe 'As a admin' do
  describe "When I visit the admin's merchant index page ('/admin/merchants')" do
    it "should see a 'disable' button next to any merchants who are not yet disabled" do
      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
      user_1 = User.create!(name: 'Grant',
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

      visit '/admin/merchants'

      within "#merchant-#{@meg.id}" do
        expect(page).to have_button('disable')
        click_on 'disable'
      end
      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("Merchant #{@meg.name} account is disabled.")

      within "#merchant-#{@brian.id}" do
        expect(page).to have_button('disable')
        click_on 'disable'
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("Merchant #{@brian.name} account is disabled.")
    end
  end
end
