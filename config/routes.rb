Rails.application.routes.draw do
  resources :surveys, :path => 'ankieta', path_names: { new: 'nowa' }, :except => [:edit, :update] do
    member do
		get 'stats', :path => 'wyniki'
	end
  end
  devise_for :administrators, :path => 'uzytkownik'
  get 'static_pages/help'
  post 'fill_survey' => 'surveys#fill', controller: 'surveys'
  root 'surveys#index'
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
