ActiveAdmin.register Province do
  permit_params :name, :code, :gst_rate, :pst_rate, :hst_rate

  index do
    selectable_column
    id_column
    column :name
    column :code
    column(:gst_rate) { |p| number_to_percentage(p.gst_rate * 100, precision: 3) }
    column(:pst_rate) { |p| number_to_percentage(p.pst_rate * 100, precision: 3) }
    column(:hst_rate) { |p| number_to_percentage(p.hst_rate * 100, precision: 3) }
    actions
  end

  filter :name
  filter :code
end
