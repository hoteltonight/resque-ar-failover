module Resque
  def self.pop_with_failover(queue)
    should_check_backup = (rand <= Resque::Plugins::ArFailover::THROTTLE)

    job  = ResqueBackup.pop(queue) if should_check_backup
    job || self.pop_without_failover(queue)
  rescue Redis::CannotConnectError, Redis::TimeoutError
    ResqueBackup.pop(queue) unless should_check_backup
  end

  class << self
    alias_method :pop_without_failover, :pop
    alias_method :pop, :pop_with_failover
  end
end
