# frozen_string_literal: true

require 'rails_helper'

feature 'User visits orders page' do
  let(:user) { create(:user) }

  background { login_as(user, scope: :user) }

  context 'with orders' do
    let(:cart) { create(:cart, :with_order, user:) }
    let!(:order) { cart.order }

    scenario 'and looks the orders page elements' do
      visit orders_path

      expect(page).to have_selector('h3', text: 'Your Orders')
      expect(page).to have_selector('table th', text: 'Order Number')
      expect(page).to have_selector('table th', text: 'Date')
      expect(page).to have_selector('table th', text: 'Total')
      expect(page).to have_link('View order details')
      expect(page).to have_link('Delete')
    end

    scenario 'and clicks on view order details link' do
      visit orders_path

      within first('table tbody tr') do
        click_on('View order details')
      end

      expect(page).to have_selector('h3', text: 'Order Details')
      expect(page).to have_selector('div', text: "Order ##{order.created_at.to_i}")
      expect(page).to have_selector('tfoot td', text: "Subtotal (#{order.cart.line_items_amount}")
      expect(page).to have_selector('tfoot td', text: "$#{order.cart.subtotal}")
      expect(page).to have_selector('tfoot td', text: "$#{order.shipping_total}")
      expect(page).to have_selector('tfoot th', text: "$#{order.total}")
    end

    scenario 'and clicks on delete link' do
      visit orders_path

      within first('table tbody tr') do
        click_on('Delete')
      end

      expect(page).to have_css('.alert.alert-success', text: 'Order was removed')
    end

    describe 'unexpected error' do
      before { allow_any_instance_of(Order).to receive(:destroy).and_return(false) }

      scenario 'and clicks on delete link' do
        visit orders_path

        within first('table tbody tr') do
          click_on('Delete')
        end

        expect(page).to have_css('.alert.alert-danger', text: 'Order can not be removed')
      end
    end
  end

  context 'without orders' do
    scenario 'and looks a empty orders message' do
      visit orders_path

      expect(page).to have_selector('h3', text: 'Your Orders')
      expect(page).to have_selector('p', text: 'No orders to show')
    end
  end
end
