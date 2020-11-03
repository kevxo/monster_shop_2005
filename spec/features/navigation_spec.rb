require 'rails_helper'

RSpec.describe 'Site Navigation' do
  describe 'As a Visitor' do
    it "I see a nav bar with links to all pages" do
      visit '/merchants'

      within 'nav' do
        click_link 'All Items'
      end

      expect(current_path).to eq('/items')

      within 'nav' do
        click_link 'All Merchants'
      end

      expect(current_path).to eq('/merchants')

      within 'nav' do
        click_link 'Home'
      end

      expect(current_path).to eq('/')

      within 'nav' do
        click_link "Cart:"
      end

      expect(current_path).to eq('/cart')

      within 'nav' do
        click_link 'Log In'
      end

      expect(current_path).to eq('/login')

      within 'nav' do
        click_link 'Register'
      end

      expect(current_path).to eq('/register/new')
    end

    it "I can see a cart indicator on all pages" do
      visit '/merchants'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/items'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/cart'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/login'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end

      visit '/register/new'

      within 'nav' do
        expect(page).to have_content("Cart: 0")
      end
    end
  end

  describe 'As a Logged In User' do
    it "I see a nav bar with links to all pages except login and register" do
      user_1 = User.create!(name: 'Grant',
                        address: '124 Grant Ave.',
                        city: 'Denver',
                        state: 'CO',
                        zip: 12345,
                        email: 'grant@coolguy.com',
                        password: 'password')
      visit '/'

      click_link 'Log In'

      expect(current_path).to eq('/login')

      fill_in :email, with: user_1.email
      fill_in :password, with: user_1.password

      click_on "Submit"

      within 'nav' do
        expect(page).to have_link("Logout")
        expect(page).to have_link("Profile")
        expect(page).to have_link("All Merchants")
        expect(page).to have_link("Cart:")
        expect(page).to have_link("All Items")
        expect(page).to have_link("Home")

        expect(page).to_not have_link("Log In")
        expect(page).to_not have_link("Register")
        expect(page).to_not have_link("Dashboard")
      end

      expect(page).to have_content("Hello, #{user_1.name}")
    end
    describe "As a logged in Merchant" do
      it "has all links a default user has along with a link to the merchang dashboard" do
        meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        user_1 = meg.users.create!(name: 'Grant',
                          address: '124 Grant Ave.',
                          city: 'Denver',
                          state: 'CO',
                          zip: 12345,
                          email: 'grant@coolguy.com',
                          password: 'password',
                          role: 1)
        visit '/'

        click_link 'Log In'

        expect(current_path).to eq('/login')

        fill_in :email, with: user_1.email
        fill_in :password, with: user_1.password

        click_on "Submit"

        within 'nav' do
          expect(page).to have_link("Logout")
          expect(page).to have_link("Profile")
          expect(page).to have_link("All Merchants")
          expect(page).to have_link("Cart:")
          expect(page).to have_link("All Items")
          expect(page).to have_link("Home")
          expect(page).to have_link("Merchant Dashboard")

          expect(page).to_not have_link("Log In")
          expect(page).to_not have_link("Register")
        end
      end
    end
      describe "As a logged in Admin" do
        it "has links to admin dashboard, all users, and no cart link" do
          user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 2)
          visit '/'

          click_link 'Log In'

          expect(current_path).to eq('/login')

          fill_in :email, with: user_1.email
          fill_in :password, with: user_1.password

          click_on "Submit"

          within 'nav' do
            expect(page).to have_link("Logout")
            expect(page).to have_link("Profile")
            expect(page).to have_link("All Merchants")
            expect(page).to have_link("All Items")
            expect(page).to have_link("Home")

            expect(page).to have_link("Admin Dashboard")
            expect(page).to have_link("All Users")

            expect(page).to_not have_link("Cart:")
            expect(page).to_not have_link("Log In")
            expect(page).to_not have_link("Register")
          end
        end
      end
      describe "As a visitor" do
        it "When trying to access any path that begins with /merchant, /admin, or /profile it returns a 404 error" do

        visit "/merchant"

        expect(page).to have_content("The page you were looking for doesn't exist (404)")

        visit "/admin"

        expect(page).to have_content("The page you were looking for doesn't exist (404)")

        visit "/profile"

        expect(page).to have_content("The page you were looking for doesn't exist (404)")
      end
    end
    describe "As a default user" do
      it "When trying to access /merchant and /admin" do
        user_1 = User.create!(name: 'Grant',
                          address: '124 Grant Ave.',
                          city: 'Denver',
                          state: 'CO',
                          zip: 12345,
                          email: 'grant@coolguy.com',
                          password: 'password',
                          role: 0)
        visit "/"

        click_link 'Log In'

        expect(current_path).to eq('/login')

        fill_in :email, with: user_1.email
        fill_in :password, with: user_1.password

        click_on "Submit"

        visit "/merchant"

        expect(page).to have_content("The page you were looking for doesn't exist (404)")

        visit "/admin"

        expect(page).to have_content("The page you were looking for doesn't exist (404)")
      end
    end
    describe "As a merchant user" do
      it "When trying to access /merchant and /admin" do
        meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
        user_1 = meg.users.create!(name: 'Grant',
                          address: '124 Grant Ave.',
                          city: 'Denver',
                          state: 'CO',
                          zip: 12345,
                          email: 'grant@coolguy.com',
                          password: 'password',
                          role: 1)
        visit "/"

        click_link 'Log In'

        expect(current_path).to eq('/login')

        fill_in :email, with: user_1.email
        fill_in :password, with: user_1.password

        click_on "Submit"

        visit "/admin"

        expect(page).to have_content("The page you were looking for doesn't exist (404)")
      end
    end
    describe "As a admin user" do
      it "When trying to access /merchant and /admin" do
        user_1 = User.create!(name: 'Grant',
                          address: '124 Grant Ave.',
                          city: 'Denver',
                          state: 'CO',
                          zip: 12345,
                          email: 'grant@coolguy.com',
                          password: 'password',
                          role: 2)
        visit "/"

        click_link 'Log In'

        expect(current_path).to eq('/login')

        fill_in :email, with: user_1.email
        fill_in :password, with: user_1.password

        click_on "Submit"

        visit "/merchant"

        expect(page).to have_content("The page you were looking for doesn't exist (404)")

        visit "/cart"

        expect(page).to have_content("The page you were looking for doesn't exist (404)")
      end
    end
  end

    describe 'As a Logged In Merchant' do
    it "I see a nav bar with links to all pages except login and register" do
      meg = Merchant.create!(name: "Meg's Bike Shop", address: '123 Bike Rd.', city: 'Denver', state: 'CO', zip: 80_203)
      user_1 = meg.users.create!(name: 'Hanna',
                        address: '124 Hanna Ave.',
                        city: 'Denver',
                        state: 'CO',
                        zip: 12345,
                        email: 'hanna@coolchick.com',
                        password: 'password',
                        role: 1)
      visit '/'

      click_link 'Log In'

      expect(current_path).to eq('/login')

      fill_in :email, with: user_1.email
      fill_in :password, with: user_1.password

      click_on "Submit"

      within 'nav' do
        expect(page).to have_link("Dashboard")
        expect(page).to have_link("Logout")
        expect(page).to have_link("Profile")
        expect(page).to have_link("All Merchants")
        expect(page).to have_link("Cart:")
        expect(page).to have_link("All Items")
        expect(page).to have_link("Home")

        expect(page).to_not have_link("Log In")
        expect(page).to_not have_link("Register")
      end
    end
  end
end
