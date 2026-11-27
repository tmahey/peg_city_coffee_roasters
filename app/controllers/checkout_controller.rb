class CheckoutController < ApplicationController
  before_action :ensure_cart_not_empty

  def new
    @provinces = Province.order(:name)
    if user_signed_in?
      @customer = Customer.new(
        name: current_user.name,
        email: current_user.email,
        address: current_user.address,
        city: current_user.city,
        postal_code: current_user.postal_code,
        province_id: current_user.province_id
      )
    else
      @customer = Customer.new
    end
  end

  def create
    @provinces = Province.order(:name)
    @customer = Customer.new(customer_params)

    if @customer.save
      if user_signed_in? && !current_user.address_complete?
        current_user.update(
          address: @customer.address,
          city: @customer.city,
          postal_code: @customer.postal_code,
          province_id: @customer.province_id
        )
      end
      session[:checkout_customer_id] = @customer.id
      redirect_to invoice_checkout_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def invoice
    @customer = Customer.find_by(id: session[:checkout_customer_id])
    return redirect_to(new_checkout_path, alert: "Please enter your address first.") unless @customer

    @items = cart_items
    @province = @customer.province
    @subtotal = cart_subtotal
    @gst_amount = (@subtotal * @province.gst_rate).round(2)
    @pst_amount = (@subtotal * @province.pst_rate).round(2)
    @hst_amount = (@subtotal * @province.hst_rate).round(2)
    @total_price = (@subtotal + @gst_amount + @pst_amount + @hst_amount).round(2)
  end

  def place_order
    @customer = Customer.find_by(id: session[:checkout_customer_id])
    return redirect_to(new_checkout_path, alert: "Please enter your address first.") unless @customer

    province = @customer.province
    subtotal = cart_subtotal
    gst = (subtotal * province.gst_rate).round(2)
    pst = (subtotal * province.pst_rate).round(2)
    hst = (subtotal * province.hst_rate).round(2)
    total = (subtotal + gst + pst + hst).round(2)

    order = Order.create!(
      customer: @customer,
      user: current_user,
      province: province,
      status: "pending",
      subtotal: subtotal,
      gst_amount: gst,
      pst_amount: pst,
      hst_amount: hst,
      total_price: total
    )

    cart_items.each do |item|
      order.order_items.create!(
        product: item[:product],
        quantity: item[:quantity],
        price_at_purchase: item[:product].price
      )
    end

    session[:cart] = {}
    if user_signed_in?
      redirect_to order_path(order), notice: "Order placed! Total: $#{format('%.2f', total)}"
    else
      redirect_to root_path, notice: "Order placed! Total: $#{format('%.2f', total)}"
    end
  end

  private

  def ensure_cart_not_empty
    redirect_to products_path, alert: "Your cart is empty." if cart_items.empty?
  end

  def customer_params
    params.require(:customer).permit(:name, :email, :address, :city, :postal_code, :province_id)
  end
end
