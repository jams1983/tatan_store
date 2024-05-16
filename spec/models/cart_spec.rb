# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cart, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:line_items).dependent(:destroy) }
  end

  describe 'instance methods' do
    subject(:cart) { create(:cart) }

    describe '.line_items_amount' do
      context 'when cart does not have line items' do
        it { expect(subject.line_items_amount).to eq 0 }
      end

      context 'when cart has line items' do
        before { create(:line_item, cart:, amount: 2) }
        it { expect(subject.line_items_amount).to eq 2 }
      end
    end
  end
end
