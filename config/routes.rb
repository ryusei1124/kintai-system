Rails.application.routes.draw do
  root 'static_pages#home'
  get  '/signup',   to: 'users#new'
  get    '/login',  to: 'sessions#new'
  post   '/login',  to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get '/edit-basic-info/:id', to: 'users#edit_basic_info', as: :basic_info
  get 'users/:id/attendances/:date/edit', to: 'attendances#edit', as: :edit_attendances
  patch 'users/:id/attendances/:date/update', to: 'attendances#update', as: :update_attendances
  #get 'users/:id/attendances/:id/edit_overtime', to: 'attendances#edit_overtime', as: :edit_overtime
  patch 'users/:id/attendances/:id/update_overtime', to: 'attendances#update_overtime', as: :update_overtime
  resources :users do
    collection { post :import }
    collection { get :on_duty }
    member do
      patch 'update_basic_info'
    end
    resources :attendances 
  end
  resources :bases 
end

