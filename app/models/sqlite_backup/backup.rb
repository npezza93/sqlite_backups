module SqliteBackup
  class Backup < ApplicationRecord
    self.table_name = "backups"

    validates :database, inclusion: { in: SqliteBackup.databases.keys }

    has_one_attached :file, service: SqliteBackup.storage_service

    scope :expired,
      -> { where(created_at: ..(SqliteBackup.retention || 1.day.ago)) }

    def formated_date
      created_at.strftime("%Y_%m_%d_%H_%M")
    end
  end
end
