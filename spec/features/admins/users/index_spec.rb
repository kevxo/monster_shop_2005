require 'rails_helper'

RSpec.describe 'As an admin' do
  describe 'When I visit the Users Index Page' do
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
      @user_2 = User.create!(name: 'Hanna',
                            address: '123 Hanna Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12453,
                            email: 'hanna@coolchick.com',
                            password: 'password',
                            role: 1)
      visit '/login'

      fill_in :email, with: @admin_1.email
      fill_in :password, with: @admin_1.password
      click_on 'Submit'
    end
    it "I see all users, the date they registered and their role" do
      visit '/admin/users'

      within "#user-#{@user_1.id}" do
        expect(page).to have_link("#{@user_1.name}")
        expect(page).to have_content(@user_1.created_at.strftime("%m-%d-%Y"))
        expect(page).to have_content(@user_1.role)
      end

      within "#user-#{@user_2.id}" do
        expect(page).to have_link("#{@user_2.name}")
        expect(page).to have_content(@user_2.created_at.strftime("%m-%d-%Y"))
        expect(page).to have_content(@user_2.role)

        click_link("#{@user_2.name}")
        expect(current_path).to eq("/admin/users/#{@user_2.id}")
      end
    end
  end
end
