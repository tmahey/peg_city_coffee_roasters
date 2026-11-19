class ApplicationController < ActionController::Base
  before_action :initialize_cart
  before_action :load_nav_categories

  helper_method :cart_items, :cart_count, :cart_subtotal

  private

  def initialize_cart
    session[:cart] ||= {}
  end

  def load_nav_categories
    @nav_categories = Category.order(:name)
  end

  def cart_items
    return [] if session[:cart].blank?

    products = Product.where(id: session[:cart].keys).index_by { |p| p.id.to_s }
    session[:cart].filter_map do |product_id, qty|
      product = products[product_id.to_s]
      next unless product

      { product: product, quantity: qty.to_i, line_total: product.price * qty.to_i }
    end
  end

  def cart_count
    session[:cart].values.sum(&:to_i)
  end

  def cart_subtotal
    cart_items.sum { |item| item[:line_total] }
  end
end
