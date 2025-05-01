require "backups/version"
require "backups/engine"
require "backups/railtie"
require "backups/create"
require "backups/restore"
require "backups/connection"

module Backups
  mattr_accessor :retention, :storage_service

  class << self
    def databases(env_name: "production")
      ActiveRecord::Base.
        configurations.
        configs_for(env_name: env_name).
        to_h { [ it.name, it.database ] }
    end

    def generate_token
      verifier.generate(
        SecureRandom.hex(16), expires_in: 5.minutes, purpose: :fetch_backups
      )
    end

    def valid_token?(token)
      verifier.verify(token, purpose: :fetch_backups).present?
    rescue ActiveSupport::MessageVerifier::InvalidSignature
      false
    end

    private

    def verifier
      Backup.generated_token_verifier
    end
  end
end
