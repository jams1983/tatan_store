# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  subject(:product) { build(:product) }

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }
  end
end
