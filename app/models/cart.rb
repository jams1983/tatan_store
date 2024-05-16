# frozen_string_literal: true

class Cart < ApplicationRecord
  include AASM

  belongs_to :user

  has_many :line_items, dependent: :destroy

  aasm do
    state :opened, initial: true
    state :closed

    event :close do
      transitions from: :opened, to: :closed
    end
  end

  def line_items_amount
    line_items.sum(:amount)
  end

  def subtotal
    line_items.sum { |line_item| line_item.product.price * line_item.amount }
  end
end
