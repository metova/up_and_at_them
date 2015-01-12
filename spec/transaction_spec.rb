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
end