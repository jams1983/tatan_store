# frozen_string_literal: true

class ProductsController < TatanStoreController
  skip_before_action :authenticate_user!, only: :index

  def index
    @products = Product.all
  end
end
