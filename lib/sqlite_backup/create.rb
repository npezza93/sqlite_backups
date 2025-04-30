module SqliteBackup
  class Create
    def initialize(name)
      @name = name
      @path = SqliteBackup.databases[name]
      @key = SecureRandom.hex(16)
    end

    def run
      execute_backup

      Backup.create(database: name).tap do
        it.file.attach(io: File.open(backup_path),
          filename: "#{name}/#{it.formated_date}.sqlite3")
        File.delete(backup_path)
      end

      Backup.where(database: name).expired.destroy_all
    end

    private

    attr_reader :name, :path, :key

    def execute_backup
      Connection.establish_connection(adapter: "sqlite3", database: path)
      Connection.connection.execute("VACUUM INTO '#{backup_path}'")
    ensure
      Connection.remove_connection
    end

    def backup_path
      Rails.root.join("tmp/#{name}_backup_#{key}")
    end
  end
end
