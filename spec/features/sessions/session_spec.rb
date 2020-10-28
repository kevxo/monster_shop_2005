require 'rails_helper'

RSpec.describe 'Logging in' do
  describe 'As a default user' do
    it 'can login with valid credentials' do
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
    end
  end

  describe 'As a merchant user' do
    it 'can login with valid credentials' do
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 1)
        visit '/login'

        fill_in :email, with: user_1.email
        fill_in :password, with: user_1.password

        click_on 'Submit'

        expect(current_path).to eq('/merchant')
    end
  end

  describe 'As a admin user' do
    it 'can login with valid credentials' do
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 2)
        visit '/login'

        fill_in :email, with: user_1.email
        fill_in :password, with: user_1.password

        click_on 'Submit'

        expect(current_path).to eq('/admin')
    end
  end
end
