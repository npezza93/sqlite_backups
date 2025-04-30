require "test_helper"

class SqliteBackupTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert SqliteBackup::VERSION
  end
end
