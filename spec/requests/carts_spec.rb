# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Carts', type: :request do
  describe 'GET #show' do
    subject { get cart_path }

    describe 'authenticated user' do
      let(:user) { create(:user) }
      let(:cart) { create(:cart, user:) }

      before do
        create_list(:line_item, 3, cart:)
        login_as(user, scope: :user)
        subject
      end

      it { expect(response).to render_template :show }
      it { expect(assigns[:current_cart]).to eq cart }
    end

    describe 'Unauthenticated user' do
      before { subject }

      it { expect(response).to redirect_to new_user_session_path }
    end
  end
end
