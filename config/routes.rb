Rails.application.routes.draw do
  resources :users, param: :_username do
    get 'question', on: :collection
    put 'change_password', on: :collection 
  end
  post '/login', to: 'authentication#login'
  get '/*a', to: 'application#not_found'
end
