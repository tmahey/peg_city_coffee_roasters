ActiveAdmin.register Order do
  permit_params :status, :customer_id, :province_id, :subtotal, :gst_amount, :pst_amount, :hst_amount, :total_price
end
