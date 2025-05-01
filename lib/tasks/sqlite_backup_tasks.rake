desc "Copy over the migrations and mount route for SqliteBackup"
namespace :sqlite_backup do
  task install: :environment do
    Rails::Command.invoke :generate, [ "sqlute_backup:install" ]
  end
end
