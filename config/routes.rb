Rails.application.routes.draw do

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
    resource :users, only: [:show, :edit, :update, :destroy], path: "user"
  end
end
