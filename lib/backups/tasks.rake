namespace :backup do
  Rails.application.config_for(:database).keys.each do |name|
    task name => :environment do
      Backups::DatabaseJob.perform_later(name)
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
