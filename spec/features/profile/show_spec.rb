require 'rails_helper'

RSpec.describe 'On the user profile page' do
  it 'it shows all of the user attributes except password' do
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
    expect(current_path).to eq('/profile')

    expect(page).to have_content(user_1.name)
    expect(page).to have_content(user_1.address)
    expect(page).to have_content(user_1.city)
    expect(page).to have_content(user_1.state)
    expect(page).to have_content(user_1.zip)
    expect(page).to have_content(user_1.email)
    expect(page).to have_link("Edit Profile")
  end
end