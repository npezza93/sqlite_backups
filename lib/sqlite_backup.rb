require "sqlite_backup/version"
require "sqlite_backup/engine"
require "sqlite_backup/create"

module SqliteBackup
  mattr_accessor :retention, :storage_service

  class << self
    def databases(env_name: "production")
      ApplicationRecord.
        configurations.
        configs_for(env_name: env_name).
        to_h { [ it.name, it.database ] }
    end
  end
end
