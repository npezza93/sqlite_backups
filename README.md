# SqliteBackup
A dead simple Rails engine to backup your Sqlite databases utilizing Active
Storage.

## Usage

To backup a database:
```bash
$ bin/rails sqlite_backup:backup:[database_name]
```

Alternatively, you can use a job:
```ruby
SqliteBackup::BackupDatabaseJob.perform_later(database_name)
SqliteBackup::BackupAllJob.perform_later
```

To restore a database:
```bash
$ bin/rails sqlite_backup:restore:[database_name]
```

## Installation
Add this line to your Gemfile:

```ruby
gem "sqlite_backup"
```

And then execute:
```bash
$ bundle
```

Then run the installer to copy over the migration and mount a route we use for
restoring:
```bash
$ bin/rails sqlite_backup:install
```

These are the available configuration options:

```ruby
config.backups.storage_service = :backups
config.backups.retention = 1.day
```

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
