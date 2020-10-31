require 'rails_helper'

RSpec.describe 'On the user orders page' do
  before :each do
    @user_1 = User.create!(name: 'Carson',
                          address: '123 Carson Ave.',
                          city: 'Denver',
                          state: 'CO',
                          zip: 12458,
                          email: 'carson@coolchick.com',
                          password: 'password',
                          role: 0)
    @order_1 = @user_1.orders.create!(name: 'Meg', 
                            address: '123 Stang Ave', 
                            city: 'Hershey', 
                            state: 'PA', 
                            zip: 17033)
    @order_2 = @user_1.orders.create!(name: 'Kevin', 
                            address: '123 Kevin Ave', 
                            city: 'Kevin Town', 
                            state: 'FL', 
                            zip: 90909)
      visit '/login'

      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      click_on 'Submit'
    end

  it 'it shows a link to to view your orders' do
    # allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)
    visit '/login'

    fill_in :email, with: @user_1.email
    fill_in :password, with: @user_1.password
    click_on 'Submit'
    expect(page).to have_content('My Orders')
    
    click_on 'My Orders'
    expect(current_path).to eq('/profile/orders')
  end

  it 'it shows the order attributes' do
    visit '/profile'
    expect(page).to have_content('My Orders')
    
    click_on 'My Orders'
    expect(current_path).to eq('/profile/orders')
  end
end 