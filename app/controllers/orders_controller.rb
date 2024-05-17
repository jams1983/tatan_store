# frozen_string_literal: true

class OrdersController < TatanStoreController
  before_action -> { redirect_to cart_path }, only: %i[new create], if: -> { current_cart.empty? }
  after_action :load_current_cart!, only: :create

  def index
    orders
  end

  def show
    order
  end

  def new
    shipping_total = 9.99
    @order = current_cart.build_order(total: current_cart.subtotal + shipping_total,
                                      shipping_total:)
  end

  def create
    @order = current_cart.build_order(order_params)
    if @order.save
      @current_cart = nil
      redirect_to root_path, notice: I18n.t('messages.orders.create.success')
    else
      flash[:alert] = I18n.t('messages.orders.create.failed')
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    if order.destroy
      flash[:notice] = I18n.t('messages.orders.destroy.success')
    else
      flash[:alert] = I18n.t('messages.orders.destroy.failed')
    end
    redirect_to orders_path
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
