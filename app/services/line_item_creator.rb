# frozen_string_literal: true

class LineItemCreator < ApplicationService
  attr_reader :current_cart, :params

  def initialize(current_cart, params)
    @current_cart = current_cart
    @params = params
  end

  def call
    line_item.amount = line_item_amount + amount_param
    line_item.save
  end

  private

  def line_item
    @line_item ||= current_cart.line_items.find_or_initialize_by(product_id: product_param)
  end

  def line_item_amount
    line_item.amount || 0
  end

  def product_param
    params[:product_id]
  end

  def amount_param
    params[:amount].to_i
  end
end
