require 'rails_helper'

RSpec.describe 'As an Admin' do
  describe "When I visit the admin's merchant index page ('/admin/merchants')" do
    before :each do
      @admin_1 = User.create!(name: 'Mr. Peanutbutter',
        address: '123 Butter Ave.',
        city: 'Los Angeles',
        state: 'LA',
        zip: 12458,
        email: 'whodatdog@coolchick.com',
        password: 'password',
        role: 2)

      @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210, status: "Disabled")
      @dog_bone = @meg.items.create(name: "Dog Bone", description: "They'll love it!", price: 21, image: "https://img.chewy.com/is/image/catalog/54226_MAIN._AC_SL1500_V1534449573_.jpg", inventory: 21)
      @pull_toy = @meg.items.create(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)
      @toilet_paper = @brian.items.create!(name: "Toilet Paper", description: "Your butt will love it!", price: 21, image: "https://cdn.shopify.com/s/files/1/1320/9925/products/WGAC_ProductPhotos_2018Packaging_TransparentBG_DLSingleRoll_large.png?v=1578973373", inventory: 12, activation_status: 'Deactivated')
      @candle = @brian.items.create!(name: "Candle", description: "Fresh af", price: 40, image: "https://images-na.ssl-images-amazon.com/images/I/71%2BkswJA5TL._AC_SX522_.jpg", inventory: 19, activation_status: 'Deactivated')

      visit '/login'

      fill_in :email, with: @admin_1.email
      fill_in :password, with: @admin_1.password
      click_on 'Submit'
    end

    it "I see all of the merchants in the system" do
      visit '/admin/merchants'

      within "#merchant-#{@brian.id}" do
        expect(page).to have_link("#{@brian.name}")
        expect(page).to have_content("#{@brian.city}")
        expect(page).to have_content("#{@brian.state}")
        expect(page).to have_button("Enable")
      end

      within "#merchant-#{@meg.id}" do
        expect(page).to have_link("#{@meg.name}")
        expect(page).to have_content("#{@meg.city}")
        expect(page).to have_content("#{@meg.state}")
        expect(page).to have_button("Disable")

        click_link("#{@meg.name}")
        expect(current_path).to eq("/admin/merchants/#{@meg.id}")
      end
    end

    it "I can disable/enable a merchant" do
      visit '/admin/merchants'

      within "#merchant-#{@meg.id}" do
        expect(page).to have_button('Disable')
        click_on 'Disable'
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("Merchant #{@meg.name} account is disabled.")

      within "#merchant-#{@brian.id}" do
        expect(page).to have_button('Enable')
        click_on 'Enable'
      end

      expect(current_path).to eq("/admin/merchants")
      expect(page).to have_content("Merchant #{@brian.name} account is enabled.")
    end

    it "after clicking on 'disable' all merchants items should be deactivated" do
      visit '/admin/merchants'

      expect(@meg.items.pluck(:activation_status)).to eq(['Activated', 'Activated'])

      within "#merchant-#{@meg.id}" do
        expect(page).to have_button('Disable')
        click_on 'Disable'
      end

      expect(@meg.items.pluck(:activation_status)).to eq(['Deactivated', 'Deactivated'])
    end
    it "after clicking on 'enable' all merchants items should be Activated" do
      visit '/admin/merchants'

      expect(@brian.items.pluck(:activation_status)).to eq(['Deactivated', 'Deactivated'])

      within "#merchant-#{@brian.id}" do
        expect(page).to have_button('Enable')
        click_on 'Enable'
      end

      expect(@brian.items.pluck(:activation_status)).to eq(['Activated', 'Activated'])
    end

    it "I can click on merchant name and be taken to their show page" do
      visit '/admin/merchants'

      click_on "#{@brian.name}"
      expect(current_path).to eq("/admin/merchants/#{@brian.id}")

      expect(page).to have_content(@brian.name)
      expect(page).to have_content(@brian.address)
      expect(page).to have_content(@brian.city)
      expect(page).to have_content(@brian.state)
      expect(page).to have_content(@brian.zip)
      expect(page).to have_content("My Items")
    end
  end
end
