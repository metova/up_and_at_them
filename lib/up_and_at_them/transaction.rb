module UpAndAtThem
  class Transaction
    def initialize(tasks)
      tasks = Array(tasks)
      tasks.each do |t|
        Commit === t or raise TypeError
      end
      @tasks = tasks
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