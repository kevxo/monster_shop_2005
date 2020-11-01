require 'rails_helper'

RSpec.describe 'On the user orders page' do
  before :each do
    @meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)

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

    @tire = @meg.items.create!(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
    @pull_toy = @meg.items.create!(name: "Pull Toy", description: "Great pull toy!", price: 10, image: "http://lovencaretoys.com/image/cache/dog/tug-toy-dog-pull-9010_2-800x800.jpg", inventory: 32)

    @order_1.item_orders.create!(item: @tire, price: @tire.price, quantity: 2)
    @order_1.item_orders.create!(item: @pull_toy, price: @pull_toy.price, quantity: 3)
      #
      # visit '/login'
      #
      # fill_in :email, with: @user_1.email
      # fill_in :password, with: @user_1.password
      # click_on 'Submit'
    end

  it 'it shows a link to to view your orders' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

    visit '/profile'
    expect(page).to have_content('My Orders')

    click_on 'My Orders'
    expect(current_path).to eq('/profile/orders')
  end

  it 'it shows the order attributes' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user_1)

    visit '/profile/orders'

    require "pry"; binding.pry
    expect(page).to have_link("Order #{@order_1.id}")
    expect(page).to have_content("#{@order_1.created_at}")
  end
end
