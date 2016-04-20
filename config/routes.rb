Rails.application.routes.draw do
  shallow do
    resource :manifest, only: [:show] do
      get 'add/:application', controller: 'manifests', action: 'add', as: :add_app_to
      resources :applications do
        resources :dirs
        resources :confs
      end
    end
  end

  root 'manifests#show'
end
