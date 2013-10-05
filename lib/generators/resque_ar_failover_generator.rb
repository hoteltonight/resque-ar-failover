require 'rails/generators'
require "rails/generators/active_record"

class ResqueArFailoverGenerator < ActiveRecord::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../', __FILE__)

  desc <<DESC
Description:
  Copies over migrations for the resque AR failover.
DESC

  # Copies the migration template to db/migrate.
  def copy_migration
    migration_template 'templates/migration.rb', 'db/migrate/create_resque_backup.rb'
  end
end
