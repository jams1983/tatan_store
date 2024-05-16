# frozen_string_literal: true

class TatanStoreController < ApplicationController
  before_action :authenticate_user!
  before_action :load_current_cart!, if: :current_user

  private

  def load_current_cart!
    current_cart
  end
end
