module Backups
  class AllJob < ApplicationJob
    def perform
      Backups.databases.each_key do |name|
        DatabaseJob.perform_later(name)
      end
    end
  end
end
