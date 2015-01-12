module UpAndAtThem
  class Transaction

    def self.[](tasks)
      new(tasks)
    end

    def initialize(tasks)
      @tasks = Array(tasks)
      run
    end

    def run
      finished_tasks = []
      begin
        @tasks.each do |task|
          task.call
          finished_tasks << task
        end
      rescue => err
        finished_tasks.reverse_each do |task|
          task.rollback
        end
        raise err
      end
    end

  end
end