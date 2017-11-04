Rails.application.routes.draw do
  get 'leads/index'

  resource  :session

  resources :messages do
    resources :comments
  end

  root 'sessions#new'
end
