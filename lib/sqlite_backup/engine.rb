module SqliteBackup
  class Engine < ::Rails::Engine
    isolate_namespace SqliteBackup

    config.backups = ActiveSupport::OrderedOptions.new

    initializer "sqlite_backup.config" do
      config.backups.each do |name, value|
        SqliteBackup.public_send(:"#{name}=", value)
      end
    end
  end
end
