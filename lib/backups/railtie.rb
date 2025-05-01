module Backups
  class Railtie < Rails::Railtie # :nodoc:
    rake_tasks do
      load "backups/restore_tasks.rake"
    end
  end
end
