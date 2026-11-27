class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products.order(:title).page(params[:page]).per(12)
  end
end
