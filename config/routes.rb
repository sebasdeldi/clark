Rails.application.routes.draw do
  resource  :session

  resources :messages do
    resources :comments
  end

  root 'sessions#new'
end
