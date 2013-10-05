module Resque
  def self.enqueue_to_with_failover(queue, klass, *args)
    self.enqueue_to_without_failover queue, klass, *args
  rescue Redis::CannotConnectError, Redis::TimeoutError
    ResqueBackup.create!(queue: queue, klass: klass, payload: args.to_json)
  end

  class << self
    alias_method :enqueue_to_without_failover, :enqueue_to
    alias_method :enqueue_to, :enqueue_to_with_failover
  end
end
