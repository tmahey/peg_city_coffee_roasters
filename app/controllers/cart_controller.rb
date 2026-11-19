class CartController < ApplicationController
  def show
    @items = cart_items
  end

  def add
    product = Product.find(params[:product_id])
    qty = [ params[:quantity].to_i, 1 ].max
    key = product.id.to_s
    session[:cart][key] = session[:cart].fetch(key, 0).to_i + qty
    redirect_back fallback_location: root_path, notice: "Added #{product.title} to your cart."
  end

  def update
    product = Product.find(params[:product_id])
    qty = params[:quantity].to_i
    key = product.id.to_s

    if qty <= 0
      session[:cart].delete(key)
    else
      session[:cart][key] = qty
    end
    redirect_to cart_path, notice: "Updated cart."
  end

  def remove
    product = Product.find(params[:product_id])
    session[:cart].delete(product.id.to_s)
    redirect_to cart_path, notice: "Removed #{product.title} from your cart."
  end
end
