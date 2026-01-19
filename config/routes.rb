Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Mount Spina at root - it handles locale routing internally
  # Routes: /:locale/*id, /:locale/, /admin/*
  mount Spina::Engine => "/"
end
