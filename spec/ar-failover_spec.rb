require 'spec_helper'

class JobOnQueue
  @queue = :queue

  def self.perform(id=nil)
    puts "Processing job #{id}" if id
  end
end

describe 'Resque' do
  let (:worker) { Resque::Worker.new(:queue) }

  before :each do
    make_redis_available
    cleanup
  end

  context 'when redis is accessible' do
    before do
      start_redis
      cleanup
    end

    describe '.enqueue' do
      it 'enqueues successfully' do
        expect { Resque.enqueue(JobOnQueue) }.to change { Resque.size(:queue) }.by(1)
      end
    end

    describe '.pop' do
      it 'pops queued items from redis' do
        2.times { Resque.enqueue(JobOnQueue) }
        expect { Resque.pop(:queue) }.to change { Resque.size_without_failover(:queue) }.from(2).to(1)
      end
    end
  end

  context 'when redis is inaccessible' do
    before do
      ensure_redis_is_dead
    end

    describe '.enqueue' do
      it 'enqueues successfully' do
        expect { Resque.enqueue(JobOnQueue) }.to change { Resque.size(:queue) }.by(1)
      end
    end

    describe '.pop' do
      it 'pops queued items from redis' do
        2.times { Resque.enqueue(JobOnQueue) }
        expect { Resque.pop(:queue) }.to change { Resque.size(:queue) }.from(2).to(1)
      end
    end
  end

  context 'when redis is unresponsive' do
    before do
      make_redis_unavailable
    end

    describe '.enqueue' do
      it 'enqueues successfully' do
        expect { Resque.enqueue(JobOnQueue) }.to change { Resque.size(:queue) }.by(1)
      end
    end

    describe '.pop' do
    end
  end

  it 'handles jobs that are in redis and the AR backend' do
    ensure_redis_is_running
    cleanup
    Resque.enqueue(JobOnQueue, 'one')
    make_redis_unavailable
    Resque.enqueue(JobOnQueue, 'two')
    make_redis_available
    Resque.size(:queue).should == 2

    job = Resque.pop(:queue)
    job['args'].should include 'two'
    Resque.size(:queue).should == 1

    job = Resque.pop(:queue)
    job['args'].should include 'one'
    Resque.size(:queue).should == 0

    Resque.pop(:queue).should be_nil
  end
end

describe 'ResqueBackup' do
  describe '#as_job' do
    let(:job) { ResqueBackup.new(queue: 'queue', klass: 'MyClass', payload: ['one', 'two', 'three'])}

    it 'converts an AR model into a Resque structure' do
      job.as_job.should == { 'class' => 'MyClass', 'args' => %w(one two three) }
    end
  end
end
