require 'rubygems'
require 'resque'
require "active_record"
require 'resque-ar-failover/resque_backup'
require 'resque-ext/enqueue'
require 'resque-ext/size'
require 'resque-ext/pop'

module Resque
  module Plugins
    module ArFailover
      THROTTLE = 1.0
    end
  end
end
