class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, require: true
  validates_presence_of :address, :city, :state, :zip, :name

  has_many :orders
  belongs_to :merchant, optional: true

  has_secure_password
  
  enum role: %w(default merchant admin)
end
