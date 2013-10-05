require 'rubygems'
require 'bundler/setup'

require 'active_record'
require 'yaml'

namespace :db do
  desc "Migrate the db"
  task :migrate do
    connection_details = YAML::load(File.open('spec/database.yml'))
    ActiveRecord::Base.establish_connection(connection_details)
    ActiveRecord::Migrator.migrate("db/migrate/")
  end
end

task :load_path do
  %w(lib).each do |path|
    $LOAD_PATH.unshift(File.expand_path("../#{path}", __FILE__))
  end
end
