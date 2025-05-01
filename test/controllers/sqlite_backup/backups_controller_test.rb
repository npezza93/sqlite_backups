require "test_helper"

module SqliteBackup
  class BackupsControllerTest < ActionDispatch::IntegrationTest
    include Engine.routes.url_helpers

    test "show with a bad token" do
      get backup_path("MySting")

      assert_response :not_found
    end

    test "show with a good token" do
      get backup_path("MyString", token: SqliteBackup.generate_token)

      assert_response :success
      assert_equal 2, JSON.parse(body)["files"].count
    end
  end
end
