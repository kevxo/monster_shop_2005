require 'rails_helper'

RSpec.describe Discount do
  describe 'Relationships' do
    it {should belong_to :merchant}
  end

  describe 'Validations' do
    it {should validate_numericality_of(:percent).is_greater_than(0)}
    it {should validate_numericality_of(:item_quantity).is_greater_than(0)}
  end

end
