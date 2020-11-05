require 'rails_helper'

RSpec.describe 'As an admin' do
  describe 'When I visit a Users Show Page' do
    before :each do
      @admin_1 = User.create!(name: 'Mr. Peanutbutter',
                              address: '123 Butter Ave.',
                              city: 'Los Angeles',
                              state: 'LA',
                              zip: 12458,
                              email: 'whodatdog@coolchick.com',
                              password: 'password',
                              role: 2)

      @user_1 = User.create!(name: 'Carson',
                            address: '123 Carson Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12458,
                            email: 'carson@coolchick.com',
                            password: 'password',
                            role: 0)

      visit '/login'

      fill_in :email, with: @admin_1.email
      fill_in :password, with: @admin_1.password
      click_on 'Submit'
    end

    it "I see the same info as a user except a link to edit their profile" do
      visit "/admin/users/#{@user_1.id}"
      expect(page).to have_content(@user_1.name)
      expect(page).to have_content(@user_1.address)
      expect(page).to have_content(@user_1.city)
      expect(page).to have_content(@user_1.state)
      expect(page).to have_content(@user_1.zip)
      expect(page).to have_content(@user_1.email)
      expect(page).to_not have_link("Edit Profile")
    end
  end
end
