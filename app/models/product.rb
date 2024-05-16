# frozen_string_literal: true

class Product < ApplicationRecord
  include Rails.application.routes.url_helpers

  validates :name, :price, presence: true
  validates :price, numericality: { greater_than: 0 }

  has_one_attached :image

  has_many :line_items, dependent: :destroy

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at name]
  end

  def image_url
    image.attached? ? url_for(image) : '/assets/noimage.jpg'
  end
end
