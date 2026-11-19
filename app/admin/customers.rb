ActiveAdmin.register Customer do
  permit_params :name, :email, :address, :city, :postal_code, :province_id
end
