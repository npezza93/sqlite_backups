class Backups::InstallGenerator < Rails::Generators::Base
  def add_route
    route "mount Backups::Engine => \"/\""
  end

  def create_migrations
    rails_command "backups:install:migrations", inline: true
  end
end
