Rails.application.routes.draw do
  get 'intents/index'

  resource  :session

  resources :messages do
    resources :comments
  end

  root 'sessions#new'
end
