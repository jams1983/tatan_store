# frozen_string_literal: true

class LineItemsController < TatanStoreController
  def create
    if LineItemCreator.call(current_cart, line_item_params)
      redirect_to root_path, notice: I18n.t('messages.line_items.create_success')
    else
      redirect_to root_path, alert: I18n.t('messages.line_items.create_failed')
    end
  end

  private

  def line_item_params
    params.require(:line_item).permit(:product_id)
  end
end
