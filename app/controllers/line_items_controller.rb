# frozen_string_literal: true

class LineItemsController < TatanStoreController
  def create
    if LineItemCreator.call(current_cart, line_item_params)
      redirect_to root_path, notice: "<strong>#{product.name}</strong> was added to cart"
    else
      redirect_to root_path, alert: "<strong>#{product.name}</strong> can not be added to cart"
    end
  end

  def destroy
    if line_item.destroy
      flash[:notice] = "<strong>#{line_item.product.name}</strong> was removed from cart"
      if current_cart.line_items.any?
        redirect_back fallback_location: cart_path
      else
        redirect_to cart_path
      end
    else
      redirect_to cart_path, alert: "<strong>#{line_item.product.name}</strong> can not be removed from cart"
    end
  end

  private

  def line_item_params
    params.require(:line_item).permit(:product_id)
  end

  def line_item
    @line_item ||= current_cart.line_items.find(params[:id])
  end

  def product
    @product ||= Product.find(line_item_params[:product_id])
  end
end
