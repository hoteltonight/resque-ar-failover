class ResqueBackup < ActiveRecord::Base
  def self.pop(queue)
    3.times do
      @job = where(queue: queue).first
      break if !@job || delete_all(id: @job.id) == 1
    end

    @job.as_job if @job
  end

  def as_job
    { "class" => klass, "args" => payload }
  end
end
