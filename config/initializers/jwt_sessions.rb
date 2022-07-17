# frozen_string_literal: true

JWTSessions.algorithm = 'HS256'
JWTSessions.encryption_key = ENV['JWT_KEY'] || Rails.application.credentials.secret_jwt_encryption_key

if Rails.env.test?
  JWTSessions.token_store = :memory
elsif Rails.env.development?
  JWTSessions.token_store = :redis, { redis_url: 'redis://127.0.0.1:6379/0' }
end
