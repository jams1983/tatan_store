# frozen_string_literal: true

class ProductsController < TatanStoreController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @products = params[:category].present? ? Product.tagged_with(params[:category]) : Product.all
  end

  def show
    @product = Product.find(params[:id])
    @related_products = @product.find_related_categories.limit(8)
  end
end
