# frozen_string_literal: true

class ProductsController < TatanStoreController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @products = params[:category].present? ? Product.tagged_with(params[:category]) : Product.all
    @products = @products.page(params[:page]).per 12

    if params[:page]
      render turbo_stream: turbo_stream.append("products", partial: "products/scrollable_list")
    end
  end

  def show
    @product = Product.find(params[:id])
    @related_products = @product.find_related_categories.limit(8)
  end
end
