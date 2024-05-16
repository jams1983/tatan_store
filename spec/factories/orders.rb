# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    total { '9.99' }
    cart
  end
end
