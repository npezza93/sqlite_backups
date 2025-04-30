$:.push File.expand_path("lib", __dir__)

require_relative "lib/sqlite_backup/version"

Gem::Specification.new do |spec|
  spec.name        = "sqlite_backup"
  spec.version     = SqliteBackup::VERSION
  spec.authors     = [ "Nick Pezza" ]
  spec.email       = [ "pezza@hey.com" ]
  spec.homepage    = "https://github.com/npezza93/sqlite_backup"
  spec.summary     = "Simple sqlite backup for Rails"
  spec.license     = "MIT"

  spec.metadata["rubygems_mfa_required"] = "true"
  spec.required_ruby_version = ">= 3.2.0"
  spec.files = Dir["{app,config,db,lib,vendor}/**/*", "LICENSE.md",
                   "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 8.0.2"
end
