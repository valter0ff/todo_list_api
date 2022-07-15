# frozen_string_literal: true

JWTSessions.algorithm = 'HS256'
JWTSessions.encryption_key = Rails.application.credentials.secret_jwt_encryption_key
JWTSessions.token_store = :redis, { redis_client: Redis.current }
