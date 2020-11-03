require 'rails_helper'

RSpec.describe 'As a admin' do
  describe "When I visit the admin's merchant index page ('/admin/merchants')" do
    it "should see a 'disable' button next to any merchants who are not yet disabled" do
      meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
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

      within "#merchant-#{meg.id}" do
        expect(page).to have_button('disable')
        click_on 'disable'
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("Merchant #{meg.name} account is disabled.")

      within "#merchant-#{brian.id}" do
        expect(page).to have_button('disable')
        click_on 'disable'
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("Merchant #{brian.name} account is disabled.")
    end

    it "after clicking on 'disable' all merchants items should be deactivated" do
      brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
      dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
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

      within "#merchant-#{brian.id}" do
        expect(page).to have_button('disable')
        click_on 'disable'
      end

      expect(brian.items.pluck(:activation_status)).to eq(['Deactivated', 'Deactivated'])
    end

    it "should see a 'enable' button next to any merchants who are disabled" do
      meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
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

      within "#merchant-#{meg.id}" do
        click_on 'disable'
      end

      within "#merchant-#{meg.id}" do
        expect(page).to have_button('enable')
        click_on 'enable'
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("Merchant #{meg.name} account is enabled.")

      within "#merchant-#{brian.id}" do
        click_on 'disable'
      end

      within "#merchant-#{brian.id}" do
        expect(page).to have_button('enable')
        click_on 'enable'
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("Merchant #{brian.name} account is enabled.")
    end

    it "after clicking on 'enable' all merchants items should be activated" do
      brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80_210)
      dog_bone = brian.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", active?:false, inventory: 21)
      pull_toy = brian.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
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

      within "#merchant-#{brian.id}" do
        click_on 'disable'
      end

      within "#merchant-#{brian.id}" do
        expect(page).to have_button('enable')
        click_on 'enable'
      end

      expect(brian.items.pluck(:activation_status)).to eq(['Activated', 'Activated'])
    end
  end
end
