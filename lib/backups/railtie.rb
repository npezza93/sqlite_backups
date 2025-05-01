module Backups
  class Railtie < Rails::Railtie # :nodoc:
    rake_tasks do
      load "backups/tasks.rake"
    end
  end
end
