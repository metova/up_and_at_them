module UpAndAtThem
  class Transaction

    def self.[](*tasks)
      new(tasks)
    end

    def initialize(tasks)
      @tasks = Array(tasks)
      @finished_tasks = []
      run
    end

    def run
      @tasks.each do |task|
        task.call
        @finished_tasks << task
      end
    rescue => err
      rollback
      raise err
    end

    def rollback
      @finished_tasks.reverse_each(&:rollback)
    end

  end
end