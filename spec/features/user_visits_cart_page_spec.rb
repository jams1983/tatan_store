# frozen_string_literal: true

require 'rails_helper'

feature 'User visits cart page' do
  let(:user) { create(:user) }
  let!(:cart) { create(:cart, user:) }

  background { login_as(user, scope: :user) }

  context 'with products in cart' do
    let!(:line_item) { create(:line_item, cart:) }

    scenario 'and looks the product in cart' do
      visit cart_path

      expect(page).to have_selector('h3', text: 'Cart')
      expect(page).to have_selector('table tbody tr td', text: line_item.product.name)
      expect(page).to have_css('.nav-item a span.badge', text: 1)
      expect(page).to have_selector('a', text: 'Checkout')
    end

    scenario 'and delete a product from cart' do
      visit cart_path

      within first('table tbody tr') do
        find(:link, 'Delete').click
      end

      expect(page).to have_css('.alert.alert-success', text: "#{line_item.product.name} was removed from cart")
      expect(page).to have_selector('p', text: 'No items to show')
    end

    context 'when user has greater than 1 added to cart' do
      let!(:line_item_two) { create(:line_item, cart:) }

      scenario 'and looks the products in cart' do
        visit cart_path

        expect(page).to have_selector('table tbody tr td', text: line_item.product.name)
        expect(page).to have_selector('table tbody tr td', text: line_item_two.product.name)
        expect(page).to have_css('.nav-item a span.badge', text: 2)
        expect(page).to have_selector('a', text: 'Checkout')
      end

      scenario 'and delete a product from cart' do
        visit cart_path

        within first('table tbody tr') do
          find(:link, 'Delete').click
        end

        expect(page).to have_css('.alert.alert-success', text: "#{line_item.product.name} was removed from cart")
        expect(page).to have_selector('table tbody tr td', text: line_item_two.product.name)
        expect(page).to_not have_selector('table tbody tr td', text: line_item.product.name)
        expect(page).to have_css('.nav-item a span.badge', text: 1)
      end
    end

    scenario 'and clicks on checkout button' do
      visit cart_path

      click_on('Checkout')
      expect(page).to have_selector('h5', text: 'Items')
      expect(page).to have_selector('h5', text: 'Order Summary')
      expect(page).to have_selector('form')
      expect(page).to have_button('Create Order')
    end

    describe 'unexpected error' do
      before { allow_any_instance_of(LineItem).to receive(:destroy).and_return(false) }

      scenario 'and tries delete a product to cart' do
        visit cart_path

        within first('table tbody tr') do
          find(:link, 'Delete').click
        end

        expect(page).to have_css('.alert.alert-danger', text: "#{line_item.product.name} can not be removed from cart")
      end
    end

  end

  context 'without products in cart' do
    scenario 'and looks empty cart message' do
      visit cart_path

      expect(page).to have_selector('h3', text: 'Cart')
      expect(page).to have_selector('p', text: 'No items to show')
      expect(page).to_not have_selector('a', text: 'Checkout')
    end
  end
end
