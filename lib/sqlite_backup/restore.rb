require "tty-prompt"

module SqliteBackup
  class Restore
    def initialize(name)
      @name = name
    end

    def run
      raise StandardError, "File not found" unless service.exist?(key)

      File.open(path, "wb") do |file|
        file.write(Zstd.decompress(service.download(key)))
      end
    end

    private

    attr_reader :name

    def path
      SqliteBackup.databases(env_name: Rails.env)[name.to_s]
    end

    def service
      ActiveStorage::Blob.services.fetch(SqliteBackup.storage_service)
    end

    def token
      SqliteBackup.generate_token
    end

    def key
      @key ||=
        TTY::Prompt.new.select("Pick a backup to restore") do |menu|
          backups[:files].each { menu.choice it["date"], it["key"] }
        end
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
