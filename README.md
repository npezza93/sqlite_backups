# SQLiteBackups

A dead simple Rails engine to backup your SQLite databases utilizing Active
Storage.

## Usage

To backup a database:
```bash
$ bin/rails backup:[database_name]
```

Alternatively, you can use a job:
```ruby
Backups::DatabaseJob.perform_later(database_name)
Backups::AllJob.perform_later
```

To restore a database:
```bash
$ bin/rails restore:[database_name]
```

## Installation
Add this line to your Gemfile:

```ruby
gem "sqlite_backups"
```

And then execute:
```bash
$ bundle
```

Then run the installer to copy over the migration and mount a route we use for
restoring:
```bash
$ bin/rails backups:install
```

These are the available configuration options:

```ruby
config.backups.storage_service = :backups
config.backups.retention = 1.day
```

The `storage_service` value points to a defined ActiveStorage service.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
