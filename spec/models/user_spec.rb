require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of :address }
    it { should validate_presence_of :city }
    it { should validate_presence_of :state }
    it { should validate_presence_of :zip }
    it { should validate_presence_of :email }
  end


  describe 'relationships' do
    it {should belong_to(:merchant).optional}
  end

  describe 'roles' do
    it 'can be created as a default user.' do
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 0)

      expect(user_1.role).to eq('default')
      expect(user_1.default?).to be_truthy
    end

    it 'can be a merchant' do
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 1)

      expect(user_1.role).to eq('merchant')
      expect(user_1.merchant?).to be_truthy
    end

    it 'can be an admin' do
      user_1 = User.create!(name: 'Grant',
                            address: '124 Grant Ave.',
                            city: 'Denver',
                            state: 'CO',
                            zip: 12_345,
                            email: 'grant@coolguy.com',
                            password: 'password',
                            role: 2)

      expect(user_1.role).to eq('admin')
      expect(user_1.admin?).to be_truthy
    end
  end
end
