# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :cart

  validates :total, presence: true
  validates :total, numericality: { greater_than: 0 }
  validates :shipping_total, numericality: { greater_than_or_equal_to: 0 }

  after_create_commit :close_cart

  private

  def close_cart
    cart.close!
  end
end
