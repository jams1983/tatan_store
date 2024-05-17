# frozen_string_literal: true

require 'rails_helper'

feature 'User visits sign up page' do
  scenario 'and finds form to sign up' do
    visit new_user_registration_path

    expect(page).to have_css('form.new_user')
    expect(page).to have_css('a', text: 'Log in')
  end

  scenario 'and clicks on log in link' do
    visit new_user_registration_path

    click_on('Log in')
    expect(page).to have_css('h2', text: 'Log in')
  end

  context 'with valid data' do
    let(:email) { 'valid@email.com' }

    scenario 'and tries sign up' do
      visit new_user_registration_path
      fill_in('Email', with: email)
      fill_in('Password', with: 'password')
      fill_in('Password confirmation', with: 'password')
      click_on('Sign up')

      expect(page).to have_css('.alert.alert-success', text: 'Welcome! You have signed up successfully.')
      expect(page).to have_css('a.nav-link', text: 'Orders')
      expect(page).to have_css('a.nav-link', text: email)
      expect(page).to have_css('.nav-item a span', text: 'Cart')
      expect(page).to have_css('.nav-item a span.badge', text: 0)
    end
  end

  context 'with invalid data' do
    scenario 'and tries sign up and the fields empty' do
      visit new_user_registration_path
      fill_in('Email', with: '')
      fill_in('Password', with: '')
      click_on('Sign up')

      expect(page).to have_css('fieldset', text: "can't be blank")
    end

    scenario 'and tries sign up and password confirmation does not match password' do
      visit new_user_registration_path
      fill_in('Email', with: 'valid@example.com')
      fill_in('Password', with: 'password')
      fill_in('Password confirmation', with: 'PassworD')
      click_on('Sign up')

      expect(page).to have_css('fieldset', text: "doesn't match Password")
    end
  end
end
