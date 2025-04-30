module SqliteBackup
  class BackupAllJob < AppliciationJob
    def perform
      SqliteBackup.databases.each_key do |name|
        BackupDatabaseJob.perform_later(name)
      end
    end
  end
end
