require 'rails_helper'

RSpec.describe 'On the profile edit page' do
  it 'a user can update their profile data' do
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
    fill_in :email, with: user_1.email
    click_on 'Submit'
    expect(current_path).to eq('/profile')
    expect(page).to have_content('Profile Updated!')

    expect(page).to have_content('54321')
  end

  it 'a user can update their password' do
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
    click_on 'Change Password'
    expect(current_path).to eq('/profile/change_password')

    fill_in :password, with: 'new password'
    fill_in :password_confirmation, with: 'new password'
    click_on 'Submit'
    expect(current_path).to eq('/profile')
    expect(page).to have_content('Password Updated!')

    click_on "Logout"

    click_on "Log In"

    fill_in :email, with: user_1.email
    fill_in :password, with: 'new password'

    click_on 'Submit'

    expect(current_path).to eq("/profile")
  end
  it "if a user updates their email with one that's taken they see a flash message" do
  user_1 = User.create!(name: 'Grant',
                        address: '124 Grant Ave.',
                        city: 'Denver',
                        state: 'CO',
                        zip: 12345,
                        email: 'grant@coolguy.com',
                        password: 'password',
                        role: 0)
  user_2 = User.create!(name: 'Hanna',
                        address: '124 Hanna Ave.',
                        city: 'Denver',
                        state: 'CO',
                        zip: 12345,
                        email: 'hannah@coolgirl.com',
                        password: 'password',
                        role: 0)
    visit '/login'
    fill_in :email, with: user_1.email
    fill_in :password, with: user_1.password
    click_on 'Submit'
    click_on 'Edit Profile'
    expect(current_path).to eq('/profile/edit')
    fill_in :email, with: user_2.email
    click_on 'Submit'
    expect(current_path).to eq('/profile')
    expect(page).to have_content('Email is already in use.')
  end
end
