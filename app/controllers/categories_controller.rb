class CategoriesController < ApplicationController
  def show
    @category = Category.find(params[:id])
    @products = @category.products.order(:title)
  end
end
