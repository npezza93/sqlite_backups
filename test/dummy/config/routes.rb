Rails.application.routes.draw do
  mount SqliteBackup::Engine => "/sqlite_backup"
end
