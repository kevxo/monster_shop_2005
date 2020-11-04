require 'rails_helper'

RSpec.describe "Merchant Items New Page" do
  describe "When I visit the merchant items new page" do
    before(:each) do
      @merchant_1 = Merchant.create(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80203)
      @tire = @merchant_1.items.create(name: "Gatorskins", description: "They'll never pop!", price: 100, image: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588", inventory: 12)
      @chain = @merchant_1.items.create(name: "Chain", description: "It'll never break!", price: 50, image: "https://www.rei.com/media/b61d1379-ec0e-4760-9247-57ef971af0ad?size=784x588", inventory: 5)
      @shifter = @merchant_1.items.create(name: "Shimano Shifters", description: "It'll always shift!", activation_status: 'Deactivated', price: 180, image: "https://images-na.ssl-images-amazon.com/images/I/4142WWbN64L._SX466_.jpg", inventory: 2)
      @user_1 = @merchant_1.users.create!(name: 'Grant', address: '124 Grant Ave.', city: 'Denver', state: 'CO', zip: 12345, email: 'grant@coolguy.com', password: 'password', role: 1)

      visit '/login'
      fill_in :email, with: @user_1.email
      fill_in :password, with: @user_1.password
      click_on 'Submit'
    end

    it 'I can fill out a form to create a new item' do
      visit 'merchant/items/new'

      fill_in :name, with: "Bike Backpack"
      fill_in :description, with: "Black and Yellow"
      fill_in :image, with: "https://images-na.ssl-images-amazon.com/images/I/61dDUwQ0VUL._AC_UX385_.jpg"
      fill_in :inventory, with: 100
      fill_in :price, with: 40
      click_on 'Submit'
      item = Item.last

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("#{item.name} has been added.")
      expect(page).to have_content(item.description)
      expect(item.activation_status).to eq("Activated")
    end

    it 'Returns default image if no image entered' do
      visit 'merchant/items/new'

      fill_in :name, with: "Bike Backpack"
      fill_in :description, with: "Black and Yellow"
      fill_in :inventory, with: 100
      fill_in :price, with: 40
      click_on 'Submit'
      item = Item.last
      expect(page).to have_css("img[src*='https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png']")
    end

    it "I cannot add a new item if details are missing" do
      visit 'merchant/items/new'

      name = ""
      price = 18
      description = "No more chaffin'!"
      image_url = "https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg"
      inventory = ""

      fill_in :name, with: name
      fill_in :price, with: price
      fill_in :description, with: description
      fill_in :image, with: image_url
      fill_in :inventory, with: inventory

      click_on "Submit"

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Inventory can't be blank")

      expect(find_field(:name).value).to eq("")
      expect(find_field(:price).value).to eq("18")
      expect(find_field(:description).value).to eq("No more chaffin'!")
      expect(find_field(:image).value).to eq("https://images-na.ssl-images-amazon.com/images/I/51HMpDXItgL._SX569_.jpg")
      expect(find_field(:inventory).value).to eq(nil)
    end
  end
end
