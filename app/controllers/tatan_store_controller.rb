# frozen_string_literal: true

class TatanStoreController < ApplicationController
  helper_method :current_cart

  before_action :authenticate_user!
  before_action :load_current_cart!, if: :current_user

  private

  def load_current_cart!
    current_cart
  end

  def current_cart
    @current_cart ||= current_user.carts.opened.first_or_create
  end
end
