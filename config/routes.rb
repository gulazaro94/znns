Rails.application.routes.draw do

  resources :survivors, only: [:create] do
    patch :update_last_location, on: :member
  end

end
