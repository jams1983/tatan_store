# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Orders', type: :request do
  describe 'GET #index' do
    subject { get orders_path }

    describe 'authenticated user' do
      let(:user) { create(:user) }
      let!(:carts) { create_list(:cart, 3, :with_order, user:) }

      before do
        login_as(user, scope: :user)
        subject
      end

      it { expect(response).to render_template :index }
      it { expect(assigns[:orders].size).to eq user.orders.size }
    end

    describe 'Unauthenticated user' do
      before { subject }

      it { expect(response).to redirect_to new_user_session_path }
      it { expect(flash[:alert]).to eq I18n.t('devise.failure.unauthenticated') }
    end
  end

  describe 'GET #new' do
    subject { get new_order_path }

    describe 'authenticated user' do
      let(:user) { create(:user) }
      let!(:cart) { create(:cart, user: ) }

      before do
        login_as(user, scope: :user)
        subject
      end

      it { expect(response).to render_template :new }
      it { expect(assigns[:order]).to_not be_nil }
      it { expect(assigns[:current_cart]).to eq cart }
    end

    describe 'Unauthenticated user' do
      before { subject }

      it { expect(response).to redirect_to new_user_session_path }
      it { expect(flash[:alert]).to eq I18n.t('devise.failure.unauthenticated') }
    end
  end

  describe 'POST #create' do
    subject { post orders_path, params: }

    let(:shipping_total) { 9.99 }
    let(:params) { { order: { total: cart.subtotal + shipping_total, shipping_total: } } }

    describe 'authenticated user' do
      let(:user) { create(:user) }
      let!(:cart) { create(:cart, user: ) }

      before { login_as(user, scope: :user) }

      describe 'success' do
        it { expect { subject }.to change(Order, :count).by(1) }

        describe 'and also' do
          before { subject }

          it { expect(response).to redirect_to root_path }
          it { expect(flash[:notice]).to eq 'Order was created' }
          it { expect(assigns[:current_cart].line_items).to be_empty }
          it { expect(cart.reload.aasm_state).to eq 'closed' }
        end
      end

      describe 'fail' do
        before { allow_any_instance_of(Order).to receive(:save).and_return(false) }

        it { expect { subject }.to_not change(Order, :count) }

        describe 'and also' do
          before { subject }

          it { expect(response).to render_template :new }
          it { expect(flash[:alert]).to eq 'Order can not be created' }
        end
      end
    end

    describe 'Unauthenticated user' do
      let!(:cart) { create(:cart ) }

      before { subject }

      it { expect(response).to redirect_to new_user_session_path }
      it { expect(flash[:alert]).to eq I18n.t('devise.failure.unauthenticated') }
    end
  end

  describe 'GET #show' do
    subject { get order_path(order) }

    describe 'authenticated user' do
      let(:user) { create(:user) }
      let!(:order) { create(:cart, :with_order, user:).order }

      before do
        login_as(user, scope: :user)
        subject
      end

      it { expect(response).to render_template :show }
      it { expect(assigns[:order]).to eq order }
    end

    describe 'Unauthenticated user' do
      let!(:order) { create(:cart, :with_order).order }

      before { subject }

      it { expect(response).to redirect_to new_user_session_path }
      it { expect(flash[:alert]).to eq I18n.t('devise.failure.unauthenticated') }
    end
  end
end
