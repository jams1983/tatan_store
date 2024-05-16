# frozen_string_literal: true

class LineItemCreator < ApplicationService
  attr_reader :current_cart, :params

  def initialize(current_cart, params)
    @current_cart = current_cart
    @params = params
  end

  def call
    line_item.amount = line_item_amount + 1
    line_item.save
  end

  private

  def line_item
    @line_item ||= current_cart.line_items.find_or_initialize_by(params)
  end

  def line_item_amount
    line_item.amount || 0
  end
end
