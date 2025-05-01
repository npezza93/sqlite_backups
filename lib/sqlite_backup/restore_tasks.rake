namespace :sqlite_backup do
  namespace :restore do
    Rails.application.config_for(:database).keys.each do |name|
      task name => :environment do
        SqliteBackup::Restore.new(name).run
      end
    end
  end
end
