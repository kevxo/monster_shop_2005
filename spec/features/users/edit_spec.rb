require 'rails_helper'

RSpec.describe 'On the profile edit page' do
  it 'a user can edit their profile data' do
    user_1 = User.create!(name: 'Grant',
                          address: '124 Grant Ave.',
                          city: 'Denver',
                          state: 'CO',
                          zip: 12_345,
                          email: 'grant@coolguy.com',
                          password: 'password',
                          role: 0)

    visit '/login'

    fill_in :email, with: user_1.email
    fill_in :password, with: user_1.password
    click_on 'Submit'
    click_on 'Edit Profile'
    expect(current_path).to eq('/profile/edit')

    fill_in :name, with: user_1.name
    fill_in :address, with: user_1.address
    fill_in :city, with: user_1.city
    fill_in :state, with: user_1.state
    fill_in :zip, with: '54321'
    click_on 'Submit'
    expect(current_path).to eq('/profile')
    expect(page).to have_content('Profile Updated!')

    expect(page).to have_content('54321')
  end
end