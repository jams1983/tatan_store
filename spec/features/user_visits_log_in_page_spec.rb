# frozen_string_literal: true

require 'rails_helper'

feature 'User visits log in page' do
  scenario 'and finds form to log in' do
    visit new_user_session_path

    expect(page).to have_css('form.new_user')
    expect(page).to have_css('a', text: 'Sign up')
    expect(page).to have_css('a', text: 'Forgot your password?')
  end

  scenario 'and clicks on sign up link' do
    visit new_user_session_path

    click_on('Sign up')
    expect(page).to have_css('h2', text: 'Sign up')
  end

  scenario 'and clicks on forgot your password link' do
    visit new_user_session_path

    click_on('Forgot your password?')
    expect(page).to have_css('h2', text: 'Forgot your password?')
  end

  context 'with existing user' do
    let(:password) { 'password' }
    let(:user) { create(:user, password:) }

    scenario 'and tries log in' do
      visit new_user_session_path

      fill_in('Email', with: user.email)
      fill_in('Password', with: password)
      click_on('Log in')

      expect(page).to have_css('.alert.alert-success', text: 'Signed in successfully.')
      expect(page).to have_css('a.nav-link', text: 'Orders')
      expect(page).to have_css('a.nav-link', text: user.email)
      expect(page).to have_css('.nav-item a span', text: 'Cart')
      expect(page).to have_css('.nav-item a span.badge', text: 0)
    end
  end

  context 'with non-existent user' do
    scenario 'and tries log in' do
      visit new_user_session_path

      fill_in('Email', with: 'non-existent@email.com')
      fill_in('Password', with: 'password')
      click_on('Log in')

      expect(page).to have_css('.alert.alert-danger', text: 'Invalid Email or password.')
    end
  end
end
