namespace :backups do
  namespace :backup do
    Rails.application.config_for(:database).keys.each do |name|
      task name => :environment do
        Backups::BackupDatabaseJob.perform_later(name)
      end
    end
  end

  namespace :restore do
    Rails.application.config_for(:database).keys.each do |name|
      task name => :environment do
        Backups::Restore.new(name).run
      end
    end
  end
end
