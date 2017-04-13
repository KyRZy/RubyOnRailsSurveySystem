Rails.application.routes.draw do
  resources :answer_respondents
  resources :respondents
  resources :answers
  resources :questions
  resources :surveys
  resources :categories
  devise_for :administrators
  get 'static_pages/home'
  get 'static_pages/help'

  root 'static_pages#home'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
