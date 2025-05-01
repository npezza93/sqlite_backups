module Backups
  class BackupsController < ActionController::Base
    before_action :verify_token

    def show
      files = Backup.where(database: params[:name]).map do
        { date: it.created_at, key: it.file.key }
      end

      render json: { name: params[:name], files: }
    end

    private

    def verify_token
      raise(ActiveRecord::RecordNotFound) unless Backups.valid_token?(params[:token])
    end
  end
end
