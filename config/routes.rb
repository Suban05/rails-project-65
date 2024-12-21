# frozen_string_literal: true

Rails.application.routes.draw do
  get 'up' => 'rails/health#show', as: :rails_health_check
  get 'service-worker' => 'rails/pwa#service_worker', as: :pwa_service_worker
  get 'manifest' => 'rails/pwa#manifest', as: :pwa_manifest

  scope module: :web do
    post 'auth/:provider', to: 'auth#request', as: :auth_request

    namespace :admin do
      root to: 'bulletins#on_moderation', filter: :under_moderation
      resources :bulletins, only: %i[index], filter: :all do
        member do
          patch :publish, :archive, :reject, :to_moderate
        end
      end
      resources :categories, except: %i[show]
    end

    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete '/auth/logout', to: 'auth#destroy'
    resource :profile, only: %i[show]

    resources :bulletins, except: %i[destroy] do
      member do
        patch :to_moderate, :archive
      end
    end

    namespace :profile do
      resource :profiles, only: %i[show]
    end

    root 'bulletins#index'
  end
end
