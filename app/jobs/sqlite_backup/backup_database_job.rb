module SqliteBackup
  class BackupDatabaseJob < AppliciationJob
    def perform(name)
      Create.new(name).run
    end
  end
end
