# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LineItem, type: :model do
  subject(:line_item) { build(:line_item) }

  describe 'validations' do
    it { should validate_numericality_of(:amount).is_greater_than(0) }
  end

  describe 'associations' do
    it { should belong_to(:product) }
    it { should belong_to(:cart) }
  end
end
