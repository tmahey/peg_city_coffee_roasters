ActiveAdmin.register Product do
  permit_params :title, :description, :price, :on_sale, :sale_price, :stock_quantity, :category_id

  filter :title
  filter :category
  filter :on_sale
  filter :price
  filter :stock_quantity
end
