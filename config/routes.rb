Rails.application.routes.draw do
  # mount_devise_token_auth_for 'User', at: 'auth/v1'
  post '/registration_user', :to => 'registrations#user_registration'
  post '/recovery_password', :to => 'registrations#recovery_password'
  get '/confirm_user', :to => 'registrations#confirm_user'
  post '/save_new_password', :to => 'registrations#save_new_password'
end