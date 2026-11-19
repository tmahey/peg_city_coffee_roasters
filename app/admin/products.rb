ActiveAdmin.register Product do
  permit_params :title, :description, :price, :stock_quantity, :category_id
end
