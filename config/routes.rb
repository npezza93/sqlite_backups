SqliteBackup::Engine.routes.draw do
  get "rails/backups/:name", to: "backups#show", as: :backup
end
