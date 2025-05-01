class SqliteBackup::InstallGenerator < Rails::Generators::Base
  def add_route
    route "mount SqliteBackup::Engine => \"/\""
  end

  def create_migrations
    rails_command "sqlite_backup:install:migrations", inline: true
  end
end
