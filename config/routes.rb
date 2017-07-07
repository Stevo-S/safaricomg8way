Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  post 'sms_notifications/start'

  post 'sms_notifications/stop'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
    resources :sms_messages
    resources :delivery_notifications
    resources :sync_orders
    resources :sms_notifications
end
