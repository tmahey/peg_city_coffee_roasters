ActiveAdmin.register Order do
  permit_params :status

  includes :customer, :user, :province, order_items: :product

  index do
    selectable_column
    id_column
    column("Customer") { |o| o.user&.name || o.customer&.name }
    column :status
    column("Products Ordered") do |o|
      o.order_items.map { |i| "#{i.product.title} x#{i.quantity}" }.join(", ")
    end
    column("Taxes") { |o| number_to_currency(o.total_taxes) }
    column(:total_price) { |o| number_to_currency(o.total_price) }
    actions
  end

  filter :status, as: :select, collection: Order::STATUSES
  filter :province
  filter :created_at
end
