# frozen_string_literal: true

require 'rails_helper'

feature 'User visits homapage' do
  let(:product) { create(:product) }

  context 'with unauthenticated user' do
    scenario 'and finds product info' do
      visit product_path(product)

      expect(page).to have_css('img.card-img-top')
      expect(page).to have_selector('h1', text: product.name)
      expect(page).to have_css('a.nav-link', text: 'Sign In')
      expect(page).to have_css('a.nav-link', text: 'Sign Up')
      expect(page).to_not have_css('.nav-item a span', text: 'Cart')
      expect(page).to_not have_css('.nav-item a span.badge', text: 0)
      expect(page).to have_button('Add to cart')
    end

    scenario 'and tries add a product to cart' do
      amount = 3
      visit product_path(product)

      fill_in('line_item[amount]', with: amount)
      click_on('Add to cart')

      expect(page).to have_css('.alert.alert-danger', text: 'You need to sign in or sign up before continuing.')
    end
  end

  context 'with authenticated user' do
    let(:user) { create(:user) }

    background { login_as(user, scope: :user) }

    scenario 'and finds product info' do
      visit product_path(product)

      expect(page).to have_css('img.card-img-top')
      expect(page).to have_selector('h1', text: product.name)
      expect(page).to have_css('.nav-item a span', text: 'Cart')
      expect(page).to have_css('.nav-item a span.badge', text: 0)
      expect(page).to have_button('Add to cart')
    end

    scenario 'and tries add a product to cart' do
      amount = 3
      visit product_path(product)

      fill_in('line_item[amount]', with: amount)
      click_on('Add to cart')

      expect(page).to have_css('.alert.alert-success', text: "#{product.name} was added to cart")
      expect(page).to have_css('.nav-item a span.badge', text: amount)
    end

    scenario 'and tries add a product to cart with empty amount' do
      visit product_path(product)

      fill_in('line_item[amount]', with: '')
      click_on('Add to cart')

      expect(page).to have_css('.alert.alert-danger', text: "#{product.name} can not be added to cart")
      expect(page).to have_css('.nav-item a span.badge', text: 0)
    end
  end
end
