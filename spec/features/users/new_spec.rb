require 'rails_helper'

RSpec.describe 'On the registration page' do
  it 'it creates a new user when the form is filled out completely' do
    visit '/'

    click_on 'Register'
    expect(current_path).to eq('/register/new')

    fill_in :name, with: 'Grant'
    fill_in :address, with: '123 Grant Ave.'
    fill_in :city, with: 'Denver'
    fill_in :state, with: 'CO'
    fill_in :zip, with: 80015
    fill_in :email, with: 'grant@yahoo.com'
    fill_in :password, with: 'password'
    fill_in :password_confirmation, with: 'password'
    click_on 'Submit'

    expect(current_path).to eq('/profile')

    expect(page).to have_content('Logged In!')
    expect(page).to have_content('Hello, Grant!')
  end

    it 'it shows a flash message when the form is incomplete' do
    visit '/'

    click_on 'Register'
    expect(current_path).to eq('/register/new')

    fill_in :name, with: 'Grant'
    fill_in :address, with: '123 Grant Ave.'
    fill_in :city, with: 'Denver'
    fill_in :state, with: 'CO'
    fill_in :zip, with: 80015
    fill_in :email, with: ''
    fill_in :password, with: 'password'
    fill_in :password_confirmation, with: 'password'
    click_on 'Submit'

    expect(current_path).to eq('/register/new')

    expect(page).to have_content("Email can't be blank.")
    expect(page).to_not have_content('You are now registered and logged in!')
  end

  it 'it shows a flash message if email already in use' do
    user_1 = User.create!(name: 'Grant',
                      address: '124 Grant Ave.',
                      city: 'Denver',
                      state: 'CO',
                      zip: 12345,
                      email: 'grant@coolguy.com',
                      password: 'password')
    visit '/'

    click_on 'Register'
    expect(current_path).to eq('/register/new')

    fill_in :name, with: 'Bob'
    fill_in :address, with: '222 Grant Ave.'
    fill_in :city, with: 'Denver'
    fill_in :state, with: 'CO'
    fill_in :zip, with: 80015
    fill_in :email, with: 'grant@coolguy.com'
    fill_in :password, with: 'password'
    fill_in :password_confirmation, with: 'password'
    click_on 'Submit'

    expect(current_path).to eq('/register/new')

    expect(page).to have_content('Email has already been taken.')
    expect(page).to_not have_content('Please fill in all required fields.')
    expect(page).to_not have_content('You are now registered and logged in!')
  end
end
