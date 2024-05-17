# frozen_string_literal: true

class LineItem < ApplicationRecord
  belongs_to :product
  belongs_to :cart

  validates :amount, presence: true, numericality: { greater_than: 0 }

  default_scope { order(:created_at) }
end
