desc "Copy over the migrations and mount route for backups"
namespace :backups do
  task install: :environment do
    Rails::Command.invoke :generate, [ "backups:install" ]
  end
end
