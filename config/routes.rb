Rails.application.routes.draw do
  post 'dns_records', to: 'records#create'
end
