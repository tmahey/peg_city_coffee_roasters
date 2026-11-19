class ProductsController < ApplicationController
  def index
    @products = Product.includes(:category).order(created_at: :desc)
    @products = @products.search_by_keyword(params[:keyword]) if params[:keyword].present?
    @products = @products.where(category_id: params[:category_id]) if params[:category_id].present?
  end

  def show
    @product = Product.includes(:category).find(params[:id])
  end
end
