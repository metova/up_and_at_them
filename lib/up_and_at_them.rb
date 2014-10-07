require "up_and_at_them/version"

module UpAndAtThem
  class Commit
    def initialize(&block)
      raise LocalJumpError unless block_given?
      @block = block
    end
    def on_rollback(&block)
      raise LocalJumpError unless block_given?
      @rollback = block
      self
    end
    def call
      @block.call
    end
    def rollback
      @rollback.call if @rollback
    end
  end

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
