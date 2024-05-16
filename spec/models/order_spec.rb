# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'validations' do
    subject(:order) { build(:order) }

    it { should validate_presence_of(:total) }
    it { should validate_numericality_of(:total).is_greater_than(0) }
    it { should validate_numericality_of(:shipping_total).is_greater_than_or_equal_to(0) }
  end

  describe 'associations' do
    it { should belong_to(:cart) }
  end
end
