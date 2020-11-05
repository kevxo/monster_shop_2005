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

      @brian = Merchant.create!(name: "Brian's Dog Shop", address: '125 Doggo St.', city: 'Denver', state: 'CO', zip: 80210, status: "Disabled")

      visit '/login'

      fill_in :email, with: @admin_1.email
      fill_in :password, with: @admin_1.password
      click_on 'Submit'
    end

    it "I visit a merchant's show page and can see their dashboard view" do
      visit "/admin/merchants/#{@brian.id}"

      expect(page).to have_content(@brian.name)
      expect(page).to have_content(@brian.address)
      expect(page).to have_content(@brian.city)
      expect(page).to have_content(@brian.state)
      expect(page).to have_content(@brian.zip)
      expect(page).to have_content("My Items")
    end
  end
end
