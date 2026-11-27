class ProductsController < ApplicationController
  def index
    @products = Product.includes(:category).order(created_at: :desc)
    @products = @products.search_by_keyword(params[:keyword]) if params[:keyword].present?
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?

    case params[:filter]
    when "on_sale" then @products = @products.on_sale_filter
    when "new" then @products = @products.new_arrivals
    when "recently_updated" then @products = @products.recently_updated
    end

    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.includes(:category).find(params[:id])
  end
end
