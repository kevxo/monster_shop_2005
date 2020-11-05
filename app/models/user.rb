class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates_presence_of :password, confirmation: true, on: :create
  validates_presence_of :password, confirmation: true, on: :update, if: :password
  validates_presence_of :address, :city, :state, :zip, :name


  has_many :orders
  belongs_to :merchant, optional: true

  has_secure_password

  enum role: %w(default merchant admin)

  def password_changed?
    !password.blank?
  end
end
