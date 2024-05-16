# frozen_string_literal: true

module ApplicationHelper
  def cart_line_items_amount
    current_cart.line_items_amount
  end
end
