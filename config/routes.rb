Rails.application.routes.draw do

  namespace :admin do
    get 'spots/new'
    get 'spots/index'
    get 'spots/create'
    get 'spots/edit'
    get 'spots/update'
    get 'spots/destroy'
    get 'spots/show'
  end
  namespace :public do
    get 'spots/new'
    get 'spots/index'
    get 'spots/create'
    get 'spots/edit'
    get 'spots/update'
    get 'spots/destroy'
    get 'spots/show'
  end
  get 'spots/new'
  get 'spots/index'
  get 'spots/create'
  get 'spots/edit'
  get 'spots/update'
  get 'spots/destroy'
  get 'spots/show'
  namespace :admin do
    get 'lists/create'
    get 'lists/update'
    get 'lists/edit'
    get 'lists/destroy'
    get 'lists/index'
  end
  namespace :public do
    get 'lists/create'
    get 'lists/update'
    get 'lists/edit'
    get 'lists/destroy'
  end
  #管理者向けルーティング
  namespace :admin do
    devise_for :admin_users, controllers: {
      sessions: 'admin/admin_users/sessions',
      passwords: 'admin/admin_users/passwords'
    }, path: ""
    resources :users
  end

  #エンドユーザー向けルーティング
  scope module: :public do
    devise_for :users, controllers: {
      sessions: 'public/users/sessions',
      registrations: 'public/users/registrations',
      passwords: 'public/users/passwords'
    }, path: "user"
    root 'homes#top'
    resource :users, only: [:show, :edit, :update, :destroy], path: "mypage"
  end
end
