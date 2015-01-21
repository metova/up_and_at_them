describe UpAndAtThem::Transaction do

  it 'rolls back past commits' do
    flags = { 1 => :pending, 2 => :pending, 3 => :pending, 4 => :pending }
    commits = (1...4).map do |i|
      UpAndAtThem::Commit.new { flags[i] = :committed; if i==3 ; raise 'uh oh!'; end }.on_rollback { flags[i] = :rolled_back }
    end
    expect { UpAndAtThem::Transaction.new commits }.to raise_error(RuntimeError)
    expect(flags[1]).to eq :rolled_back
    expect(flags[4]).to eq :pending
    expect(flags[3]).to eq :committed
    expect(flags[2]).to eq :rolled_back
  end

  it 'rolls back in reverse commit order' do
    flags = { 1 => -1, 2 => -1, 3 => -1, 4 => -1 }
    commits = (1...4).map do |i|
      UpAndAtThem::Commit.new { flags[i] = -1; if i==3 ; raise 'uh oh!'; end }.on_rollback { flags[i] = Time.now; sleep 1 }
    end
    expect { UpAndAtThem::Transaction.new commits }.to raise_error(RuntimeError)
    expect(flags[4].to_f).to eq -1
    expect(flags[3].to_f).to be < flags[2].to_f
    expect(flags[2].to_f).to be < flags[1].to_f
  end

  it 'allows no-rollback commits' do
    flags = {1 => :pending, 2 => :pending, 3 => :pending, 4 => :pending}
    commits = (1...4).map do |i|
      UpAndAtThem::Commit.new { flags[i] = :committed; if i==3 ; raise 'fail!'; end }
    end
    expect { UpAndAtThem::Transaction.new commits }.to raise_error(RuntimeError)
    expect(flags[4]).to eq :pending
    expect(flags[3]).to eq :committed
    expect(flags[2]).to eq :committed
    expect(flags[1]).to eq :committed
  end

  describe '.[]' do
    it 'instantiates a new Transaction' do
      commit = -> { raise 'fail!' }
      expect { UpAndAtThem::Transaction[commit] }.to raise_error(RuntimeError)
    end
  end

  describe '#rollback' do
    it 'forces a rollback each commit in the transaction' do
      result = [true, true]
      commit1 = UpAndAtThem::Commit.new { result[0] = false }.on_rollback { result[0] = true }
      commit2 = UpAndAtThem::Commit.new { result[1] = false }.on_rollback { result[1] = true }
      transaction = UpAndAtThem::Transaction[commit1, commit2]
      expect(result).to eq [false, false]
      transaction.rollback
      expect(result).to eq [true, true]
    end
  end

  describe 'duck typed Commits' do
    class TestCommit
      attr_reader :state

      def initialize(fail = false)
        @fail = fail
        @state = :pending
      end

      def call
        @state = :committed
        raise if @fail
      end

      def rollback
        @state = :rolled_back
      end
    end

    it 'runs #call on each commit' do
      commit = TestCommit.new
      UpAndAtThem::Transaction[commit]
      expect(commit.state).to eq :committed
    end

    it 'runs #rollback when the commit fails' do
      commit1 = TestCommit.new
      commit2 = TestCommit.new(true)
      expect { UpAndAtThem::Transaction[commit1, commit2] }.to raise_error
      expect(commit1.state).to eq :rolled_back
      expect(commit2.state).to eq :committed
    end

  end

end