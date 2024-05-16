# frozen_string_literal: true

FactoryBot.define do
  factory :cart do
    user
  end

  trait :with_order do
    transient do
      line_items_count { rand(1..3) }
    end

    after(:create) do |cart, context|
      create_list(:line_item, context.line_items_count, cart:)
      create(:order, cart:, total: cart.subtotal + 9.99, shipping_total: 9.99)
    end
  end
end
