require 'rails_helper'

RSpec.describe "As a Merchant Employee" do
  describe "When I visit an Item Edit Page" do
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

    it 'I can see the prepopulated fields of that item' do
      visit "/merchant/items/#{@tire.id}/edit"

      expect(find_field(:name).value).to eq "Gatorskins"
      expect(find_field(:price).value).to eq '$100.00'
      expect(find_field(:description).value).to eq "They'll never pop!"
      expect(find_field(:image).value).to eq("https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588")
      expect(find_field(:inventory).value).to eq '12'
    end

    it "I can edit a form" do
      visit "/merchant/items/#{@tire.id}/edit"

      fill_in 'Name', with: "LizardSkins"
      fill_in 'Price', with: 14
      fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
      fill_in 'Image', with: "https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588"
      fill_in 'Inventory', with: 114

      click_on "Submit"

      expect(current_path).to eq("/merchant/items")
      expect(page).to have_content("LizardSkins")
      expect(page).to have_content("$14.00")
      expect(page).to have_content("They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail.")
      expect(page).to have_css("img[src*='https://www.rei.com/media/4e1f5b05-27ef-4267-bb9a-14e35935f218?size=784x588']")
      expect(page).to have_content("114")

      expect(page).to_not have_content("Gatorskins")

      @tire.reload
      expect(page).to have_content("#{@tire.name} has been updated.")
      expect(@tire.activation_status).to eq("Activated")
    end

    it 'I get a flash message if entire form is not filled out' do
      visit "/merchant/items/#{@tire.id}/edit"

      fill_in 'Name', with: ""
      fill_in 'Price', with: 0
      fill_in 'Description', with: ""
      fill_in 'Image', with: ""
      fill_in 'Inventory', with: 1

      click_button "Submit"

      expect(page).to have_content("Name can't be blank")
      expect(page).to have_content("Description can't be blank")
      expect(page).to have_content("Price must be greater than 0")
    end

    it "I see default image if no image is entered" do
      visit "/merchant/items/#{@tire.id}/edit"

      fill_in 'Name', with: "LizardSkins"
      fill_in 'Price', with: 14
      fill_in 'Description', with: "They're a bit more expensive, and they kinda do pop sometimes, but whatevs.. this is retail."
      fill_in 'Image', with: ""
      fill_in 'Inventory', with: 114

      click_on "Submit"

      expect(page).to have_css("img[src*='https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png']")
    end
  end
end
