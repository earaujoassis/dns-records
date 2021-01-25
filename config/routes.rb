Rails.application.routes.draw do
  get 'health_check', to: 'health_check#index'
  root 'health_check#index'
  post 'dns_records', to: 'records#create'
  get 'dns_records', to: 'records#index'
end
