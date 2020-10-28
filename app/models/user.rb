class User < ApplicationRecord
  validates :name, uniqueness: true, presence: true
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, require: true
  validates_presence_of :address, :city, :state, :zip
  has_secure_password

end