module Backups
  class Backup < ApplicationRecord
    self.table_name = "backups"

    validates :database, inclusion: { in: Backups.databases.keys }

    has_one_attached :file, service: Backups.storage_service

    scope :expired,
      -> { where(created_at: ..(Backups.retention || 1.day).ago) }

    def formated_date
      created_at.strftime("%Y-%m-%d_%H:%M")
    end
  end
end
