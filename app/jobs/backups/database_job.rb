module Backups
  class DatabaseJob < ApplicationJob
    def perform(name)
      Create.new(name).run
    end
  end
end
