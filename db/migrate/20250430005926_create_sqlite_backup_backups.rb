class CreateSqliteBackupBackups < ActiveRecord::Migration[8.0]
  def change
    create_table :backups do |t|
      t.string :database

      t.timestamps
    end
  end
end
