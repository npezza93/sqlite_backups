class SqliteBackup::Connection < ActiveRecord::Base
  self.abstract_class = true
end
