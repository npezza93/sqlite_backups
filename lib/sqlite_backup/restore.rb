module SqliteBackup
  class Restore
    def initialize(name, date)
      @name = name
      @date = date
    end

    def run
      raise StandardError, "File not found" unless service.exist?(key)

      File.open(path, "wb") do |file|
        file.write(service.download(key))
      end
    end

    private

    attr_reader :name, :date

    def path
      SqliteBackup.databases(env_name: :development)[name]
    end

    def service
      ActiveStorage::Blob.services.fetch(SqliteBackup.storage_service)
    end

    def key
      "#{name}/#{date}.sqlite3"
    end
  end
end
