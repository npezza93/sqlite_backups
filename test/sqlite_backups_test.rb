require "test_helper"

class SqliteBackupsTest < ActiveSupport::TestCase
  test "it has a version number" do
    assert Backups::VERSION
  end
end
