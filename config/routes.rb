Rails.application.routes.draw do
  resources :answer_respondents
  resources :respondents
  resources :answers
  resources :questions
  resources :surveys do
    member do
		get 'stats'
	end
  end
  resources :categories
  devise_for :administrators
  get 'static_pages/home'
  get 'static_pages/help'
  post 'fill_survey' => 'surveys#fill', controller: 'surveys'
  root 'surveys#index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
