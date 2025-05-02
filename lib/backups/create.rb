module Backups
  class Create
    def initialize(name)
      @name = name
      @path = Backups.databases[name.to_s]
      @key = SecureRandom.hex(16)
    end

    def run
      execute_backup

      Backup.create(database: name).tap do
        it.file.attach(io: compressed_data, filename: key)
        File.delete(backup_path)
      end

      expire_old_backups
    end

    private

    attr_reader :name, :path, :key

    def execute_backup
      `sqlite3 #{path} '.backup #{backup_path}'`
    end

    def compressed_data
      StringIO.new(ActiveSupport::Gzip.compress(File.read(backup_path))).tap do
        it.rewind
      end
    end

    def backup_path
      Rails.root.join("tmp/#{name}_backup_#{key}")
    end

    def expire_old_backups
      Backup.where(database: name).expired.each do
        it.file.purge
        it.destroy
      end
    end
  end
end
