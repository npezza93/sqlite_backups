# frozen_string_literal: true

module SqliteBackup
  class Railtie < Rails::Railtie # :nodoc:
    rake_tasks do
      load "sqlite_backup/restore_tasks.rake"
    end
  end
end
