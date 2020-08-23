Rails.application.routes.draw do
  devise_for :users , controllers: { registrations: 'users/registrations'}
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  resources :users, only: [:edit,:update,:index] do
    member do
      get 'messages'
    end
  end

  resources :messages do
    collection do
      get 'sent'
    end
  end

  get '/archived' => 'messages#archived', as: 'archived'
  patch '/archive' => 'messages#archive', as: 'archive', defaults: {format: 'js'}
  patch '/archive_multiple' => 'messages#archive_multiple', as: 'archive_multiple', defaults: {format: 'js'}

  # API routes
  namespace :api do
    # API version 1 routes
    namespace :v1 do
      resources :messages, only: [:index, :create, :show] do
        collection do
          get 'sent'
        end
      end

      get   '/profile' => 'users#show'
      patch '/profile' => 'users#update'
    end
  end
end
