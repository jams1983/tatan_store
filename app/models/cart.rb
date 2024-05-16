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
end
