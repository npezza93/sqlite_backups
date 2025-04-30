module SqliteBackup
  class BackupDatabaseJob < ApplicationJob
    def perform(name)
      Create.new(name).run
    end
  end
end
