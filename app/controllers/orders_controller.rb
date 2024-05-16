# frozen_string_literal: true

class OrdersController < TatanStoreController
  def index
    orders
  end

  def new
    shipping_total = 9.99
    @order = current_cart.build_order(total: current_cart.subtotal + shipping_total,
                                      shipping_total:)
  end

  def create
    @order = current_cart.build_order(order_params)
    if @order.save
      redirect_to root_path, notice: 'Order was created'
    else
      flash[:alert] = 'Order can not be created'
      render :new, status: :unprocessable_entity
    end
  end

  def show
    order
  end

  private

  def order_params
    params.require(:order).permit(:total, :shipping_total)
  end

  def orders
    @orders ||= current_user.orders.order('created_at DESC')
  end

  def order
    @order ||= orders.find(params[:id])
  end
end
