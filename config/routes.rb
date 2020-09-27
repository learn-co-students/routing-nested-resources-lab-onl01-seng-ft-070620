Rails.application.routes.draw do
  resources :artists do
    resources :songs, only: %i[show index]
  end
  resources :songs
end
