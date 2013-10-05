require 'rubygems'
require 'bundler/setup'
require 'rspec'

require 'ruby-debug'
require 'resque'
require 'resque-ar-failover'

Bundler.require(:default, :test)

$TESTING = true

RSpec.configure do |config|
  config.before(:suite) do
    $redis_path = `which redis-server`.chomp
    if $redis_path.empty?
      abort "redis-server couldn't be found on your system. Check that redis is installed and available in your $PATH"
    end

    $base_path = File.dirname(File.expand_path(__FILE__))

    Resque.redis = 'localhost:9736'

    connection_details = YAML::load(File.open(File.join($base_path, 'database.yml')))
    ActiveRecord::Base.establish_connection(connection_details)
  end

  config.after(:suite) do
    kill_redis
  end
end

def start_redis
  system("#{$redis_path} #{File.join($base_path, 'redis-test.conf')}") or abort 'Unable to starte redis'
end

def cleanup
  ResqueBackup.delete_all
  Resque.redis.flushall if is_redis_alive?
end

def ensure_redis_is_running
  return if is_redis_alive?

  start_redis
end

def ensure_redis_is_dead
  while is_redis_alive? do
    kill_redis
  end
end

def make_redis_unavailable
  Resque.redis = 'google.com:9736'
end

def make_redis_available
  Resque.redis = 'localhost:9736'
end

def redis_pid
  pid = `ps -e -o pid,command | grep [r]edis-test`.split(" ")[0].to_i
end

def kill_redis(signal='KILL')
  Process.kill(signal, redis_pid) if is_redis_alive?
end

def is_redis_alive?
  redis_pid != 0
end
