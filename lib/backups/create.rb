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
        File.delete("#{backup_path}.gz")
      end

      expire_old_backups
    end

    private

    attr_reader :name, :path, :key

    def execute_backup
      sdb = SQLite3::Database.new(path)
      ddb = SQLite3::Database.new(backup_path)

      b = SQLite3::Backup.new(ddb, "main", sdb, "main")
      current_progress = 0
      begin
        b.step(1)
        progress = (((b.pagecount - b.remaining) / b.pagecount.to_f) * 100.0).to_i
        if progress > current_progress
          current_progress = progress
          print "\r#{current_progress}%"
        end
      end while b.remaining > 0
      b.finish
      puts ""
    end

    def compressed_data
      gzip_path = "#{backup_path}.gz"
      Zlib::GzipWriter.open(gzip_path) do |gz|
        File.open(backup_path, "rb") do |f|
          IO.copy_stream(f, gz)
        end
      end
      File.open(gzip_path, "rb")
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
