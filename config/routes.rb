Rails.application.routes.draw do
  get "/about", to: "pages#show", defaults: { slug: "about" }, as: :about
  get "/contact", to: "pages#show", defaults: { slug: "contact" }, as: :contact
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root "products#index"

  resources :products, only: [ :index, :show ]
  resources :categories, only: [ :show ]
  resources :orders, only: [ :index, :show ]

  resource :cart, only: [ :show ], controller: "cart" do
    post "add/:product_id", to: "cart#add", as: :add_to
    patch "update/:product_id", to: "cart#update", as: :update_item
    delete "remove/:product_id", to: "cart#remove", as: :remove_item
  end

  resource :checkout, only: [ :new, :create ], controller: "checkout" do
    get :invoice
    post :place_order
  end
end
