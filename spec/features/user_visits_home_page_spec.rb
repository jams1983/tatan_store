# frozen_string_literal: true

require 'rails_helper'

feature 'User visits homapage' do
  background do
    create_list(:product, 3)
  end

  context 'with unauthenticated user' do
    scenario 'and finds app name and links in the nav' do
      visit root_path

      expect(page).to have_css('a.navbar-brand', text: 'Tatan Store')
      expect(page).to have_css('a.nav-link', text: 'Products')
      expect(page).to have_css('a.nav-link', text: 'Sign In')
      expect(page).to have_css('a.nav-link', text: 'Sign Up')
    end

    scenario 'and finds a banner' do
      visit root_path

      expect(page).to have_css('.banner')
    end

    scenario 'and finds products' do
      visit root_path

      expect(page).to have_css('.card')
      expect(page).to have_css('.card img')
      expect(page).to have_css('.card .card-body h5', text: Product.first.name)
      expect(page).to have_css('.card .card-body span', text: "$#{Product.first.price}")
      expect(page).to have_css('.card .card-footer button', text: 'Add to cart')
    end

    scenario 'and tries add a product to cart' do
      visit root_path

      within first('.card') do
        find(:button, 'Add to cart').click
      end

      expect(page).to have_css('.alert.alert-danger', text: 'You need to sign in or sign up before continuing.')
      expect(page).to have_css('h2', text: 'Log in')
    end
  end

  context 'with unauthenticated user' do
    let(:user) { create(:user) }

    background { login_as(user, scope: :user) }

    scenario 'and finds app name and links in the nav' do
      visit root_path

      expect(page).to have_css('a.navbar-brand', text: 'Tatan Store')
      expect(page).to have_css('a.nav-link', text: 'Products')
      expect(page).to have_css('a.nav-link', text: 'Orders')
      expect(page).to have_css('a.nav-link', text: user.email)
      expect(page).to have_css('.nav-item a span', text: 'Cart')
      expect(page).to have_css('.nav-item a span.badge', text: 0)
    end

    scenario 'and tries add a product to cart' do
      visit root_path
      product_name = ''

      within first('.card') do
        product_name = find('h5').text
        find(:button, 'Add to cart').click
      end

      expect(page).to have_css('.alert.alert-success', text: "#{product_name} was added to cart")
      expect(page).to have_css('.nav-item a span.badge', text: 1)
    end

    describe 'unexpected error' do
      before { allow(LineItemCreator).to receive(:call).and_return(false) }

      scenario 'and tries add a product to cart' do
        visit root_path
        product_name = ''

        within first('.card') do
          product_name = find('h5').text
          find(:button, 'Add to cart').click
        end

        expect(page).to have_css('.alert.alert-danger', text: "#{product_name} can not be added to cart")
      end
    end
  end
end
