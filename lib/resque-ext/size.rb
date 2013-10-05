module Resque
  def self.size_with_failover(queue)
    size_in_redis =  begin
      self.size_without_failover(:queue)
    rescue Redis::CannotConnectError, Redis::TimeoutError
      0
    end

    size_in_redis + ResqueBackup.where(queue: queue).count
  end

  class << self
    alias_method :size_without_failover, :size
    alias_method :size, :size_with_failover
  end
end
