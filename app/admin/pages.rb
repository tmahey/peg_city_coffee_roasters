ActiveAdmin.register Page do
  permit_params :title, :slug, :content
  actions :index, :show, :edit, :update

  filter :title
  filter :slug
end
