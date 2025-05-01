module Backups
  class BackupAllJob < ApplicationJob
    def perform
      Backups.databases.each_key do |name|
        BackupDatabaseJob.perform_later(name)
      end
    end
  end
end
