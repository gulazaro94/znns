Rails.application.routes.draw do

  resources :survivors, only: [:create] do
    patch :update_last_location, on: :member
    post 'notify_infection/:infected_id', action: :notify_infection, on: :member
    post :trade_items, on: :collection
  end

  namespace :reports do
    get :infected_percentage
    get :non_infected_percentage
    get :items_quantity_average
    get :lost_points
  end

end
