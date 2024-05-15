# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Products', type: :request do
  describe 'GET #index' do
    subject { get root_path }

    describe 'authenticated user' do
      let(:user) { create(:user) }

      before do
        login_as(user)
        subject
      end

      it { expect(response).to render_template :index }
    end

    describe 'Unauthenticated user' do
      before { subject }

      it { expect(response).to render_template :index }
    end
  end
end
