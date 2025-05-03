require "cli/ui"

module Backups
  class Restore
    def initialize(name)
      @name = name
    end

    def run
      raise StandardError, "No backups found" if backups["files"].blank?
      raise StandardError, "File not found" unless service.exist?(key)

      File.open(path, "wb") do |file|
        file.write(ActiveSupport::Gzip.decompress(service.download(key)))
      end
    end

    private

    attr_reader :name

    def path
      Backups.databases(env_name: Rails.env)[name.to_s]
    end

    def service
      ActiveStorage::Blob.services.fetch(Backups.storage_service)
    end

    def token
      Backups.generate_token
    end

    def key
      @key ||=
        if backups["files"].count == 1
          backups["files"].first["key"]
        else
          CLI::UI.ask("Pick a backup to restore", options:).then do |date|
            backups["files"].find { it["date"].to_s == date }["key"]
          end
        end
    end

    def options
      backups[:files].pluck("date").map(&:to_s)
    end

    def uri
      host = `RAILS_ENV=production bin/rails runner 'puts Rails.application.config.x.url'`
      URI("#{host.strip}/rails/backups/#{name}").
        tap { it.query = URI.encode_www_form(token:) }
    end

    def backups
      @backups ||= begin
        ActiveSupport.parse_json_times = true
        ActiveSupport::JSON.
          decode(Net::HTTP.get_response(uri).body).with_indifferent_access
      end
    end
  end
end
