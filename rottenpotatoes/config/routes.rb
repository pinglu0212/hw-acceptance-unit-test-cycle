Rottenpotatoes::Application.routes.draw do
  root 'movies#index'
  resources :movies
  get '/movies/:id/find_director' => 'movies#find_director', :as => :find_director

end