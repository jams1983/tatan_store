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
          it { expect(flash[:notice]).to eq "<strong>#{product.name}</strong> was added to cart" }
        end
      end

      context 'when line item exists' do
        let(:cart) { create(:cart, user:) }
        let!(:line_item) { create(:line_item, product:, cart:) }

        it { expect { subject }.to_not change(LineItem, :count) }

        describe 'and also' do
          before { subject }

          it { expect(response).to redirect_to root_path }
          it { expect(flash[:notice]).to eq "<strong>#{product.name}</strong> was added to cart" }
        end
      end

      context 'when LineItemCreator service fails' do
        before do
          allow(LineItemCreator).to receive(:call).and_return(false)
          subject
        end

        it { expect(response).to redirect_to root_path }
        it { expect(flash[:alert]).to eq "<strong>#{product.name}</strong> can not be added to cart" }
      end
    end

    describe 'Unauthenticated user' do
      before { subject }

      it { expect(response).to redirect_to new_user_session_path }
      it { expect(flash[:alert]).to eq I18n.t('devise.failure.unauthenticated') }
    end
  end

  describe 'DELETE #destroy' do
    subject { delete line_item_path(line_item) }

    describe 'authenticated user' do
      let(:user) { create(:user) }
      let(:cart) { create(:cart, user:) }
      let!(:line_item) { create(:line_item, cart:) }

      before { login_as(user, scope: :user) }

      context 'when a line item can be removed' do
        it { expect { subject }.to change(LineItem, :count).by(-1) }

        describe 'and also' do
          before { subject }

          it { expect(response).to redirect_to cart_path }
          it { expect(flash[:notice]).to eq "<strong>#{line_item.product.name}</strong> was removed from cart" }
        end
      end

      context 'when a line item can not be removed' do
        before { allow_any_instance_of(LineItem).to receive(:destroy).and_return(false) }

        it { expect { subject }.to_not change(LineItem, :count) }

        describe 'and also' do
          before { subject }

          it { expect(response).to redirect_to cart_path }
          it { expect(flash[:alert]).to eq "<strong>#{line_item.product.name}</strong> can not be removed from cart" }
        end
      end
    end

    describe 'Unauthenticated user' do
      before { subject }

      let(:line_item) { 1 }

      it { expect(response).to redirect_to new_user_session_path }
    end
  end
end
