Rails.application.routes.draw do
  post 'dns_records', to: 'records#create'
  get 'dns_records', to: 'records#index'
end
