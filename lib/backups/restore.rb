require "cli/ui"

module Backups
  class Restore
    def initialize(name)
      @name = name
    end

    def run
      raise StandardError, "No backups found" if backups["files"].blank?
      raise StandardError, "File not found" unless service.exist?(key)

      download
      decompress

      File.delete(path) if File.exist?(path)
      FileUtils.mv(download_path, path)
      File.delete("#{download_path}.gz") if File.exist?("#{download_path}.gz")
      File.delete(download_path) if File.exist?(download_path)

      puts "Restore complete!"
    end

    private

    attr_reader :name

    def download
      return if File.exist?("#{download_path}.gz") || File.exist?(download_path)

      downloaded_total = 0
      File.open("#{download_path}.gz", "wb") do |file|
        service.download(key) do |chunk|
          file.write(chunk)
          downloaded_total += chunk.bytesize
          print "\rDownloading: #{((downloaded_total / size.to_f) * 100.0).to_i}%"
        end
      end
      puts
    end

    def decompress
      return if File.exist?(download_path)

      puts "Decompressing..."
      File.open("#{download_path}.gz", "rb") do |file|
        File.open(download_path, "wb") do |out|
          Zlib::GzipReader.wrap(file) do |gz|
            out.write(gz.read)
          end
        end
      end

      File.delete("#{download_path}.gz")
    end

    def path
      Backups.databases(env_name: Rails.env)[name.to_s]
    end

    def download_path
      Rails.root.join("tmp/#{key}")
    end

    def service
      ActiveStorage::Blob.services.fetch(Backups.storage_service)
    end

    def token
      Backups.generate_token
    end

    def key
      backup_file[:key]
    end

    def size
      backup_file[:size]
    end

    def backup_file
      @backup_file ||=
        if backups["files"].count == 1
          backups["files"].first
        else
          CLI::UI.ask("Pick a backup to restore", options:).then do |date|
            backups["files"].find { it["date"].to_s == date }
          end
        end.to_h.with_indifferent_access
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
