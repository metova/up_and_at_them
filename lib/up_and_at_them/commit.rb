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
end