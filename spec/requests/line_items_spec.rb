# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LineItems', type: :request do
  describe 'POST #create' do
    subject { post line_items_path, params: }

    let(:product) { create(:product) }
    let(:params) { { line_item: { product_id: product.id } } }

    describe 'authenticated user' do
      let(:user) { create(:user) }

      before { login_as(user, scope: :user) }

      context 'when line item does not exist' do
        it { expect { subject }.to change(LineItem, :count).by(1) }

        describe 'and also' do
          before { subject }

          it { expect(response).to redirect_to root_path }
          it { expect(flash[:notice]).to eq I18n.t('messages.line_items.create_success') }
        end
      end

      context 'when line item exists' do
        let(:cart) { create(:cart, user:) }
        let!(:line_item) { create(:line_item, product:, cart:) }

        it { expect { subject }.to_not change(LineItem, :count) }

        describe 'and also' do
          before { subject }

          it { expect(response).to redirect_to root_path }
          it { expect(flash[:notice]).to eq I18n.t('messages.line_items.create_success') }
        end
      end

      context 'when LineItemCreator service fails' do
        before do
          allow(LineItemCreator).to receive(:call).and_return(false)
          subject
        end

        it { expect(response).to redirect_to root_path }
        it { expect(flash[:alert]).to eq I18n.t('messages.line_items.create_failed') }
      end
    end

    describe 'Unauthenticated user' do
      before { subject }

      it { expect(response).to redirect_to new_user_session_path }
      it { expect(flash[:alert]).to eq I18n.t('devise.failure.unauthenticated') }
    end
  end
end
