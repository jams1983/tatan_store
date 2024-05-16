# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products', type: :request do
  describe 'GET #index' do
    subject { get root_path }

    let!(:products) { create_list(:product, 3) }

    describe 'authenticated user' do
      let(:user) { create(:user) }

      before do
        login_as(user)
        subject
      end

      it { expect(response).to render_template :index }
      it { expect(assigns[:products].size).to eq products.size }
      it { expect(assigns[:current_cart]).to be_nil }
    end

    describe 'Unauthenticated user' do
      before { subject }

      it { expect(response).to render_template :index }
      it { expect(assigns[:products].size).to eq products.size }
    end
  end
end
