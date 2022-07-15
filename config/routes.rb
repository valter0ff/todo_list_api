# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  namespace :api do
    namespace :v1 do
      resource :user, only: %i[create]
      resource :session, only: %i[create destroy]
      resource :current_user, only: %i[show]
    end
  end
end
