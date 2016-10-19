Rails.application.routes.draw do

  resources :survivors, only: [:create] do
    patch :update_last_location, on: :member
    post 'notify_infection/:infected_id', action: :notify_infection, on: :member
    post :trade_items, on: :collection
  end

end
