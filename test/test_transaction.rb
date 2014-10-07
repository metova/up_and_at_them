require 'minitest/autorun'
require 'up_and_at_them'

class TransactionTest < MiniTest::Test
  def test_rollback_past_commits
    flags = {1 => :pending, 2 => :pending, 3 => :pending, 4 => :pending}

    commits = Array.new
    (1...4).each do |i|
      commits << UpAndAtThem::Commit.new { flags[i] = :committed; if i==3 ; raise 'uh oh!'; end }.on_rollback { flags[i] = :rolled_back }
    end

    assert_raises RuntimeError do
      UpAndAtThem::Transaction.new commits
    end
    assert_equal :pending, flags[4]
    assert_equal :committed, flags[3]
    assert_equal :rolled_back, flags[2]
    assert_equal :rolled_back, flags[1]
  end

  def test_rollback_in_reverse_commit_order
    flags = {1 => -1, 2 => -1, 3 => -1, 4 => -1}

    commits = Array.new
    (1...4).each do |i|
      commits << UpAndAtThem::Commit.new { flags[i] = -1; if i==3 ; raise 'uh oh!'; end }.on_rollback { flags[i] = Time.now; sleep 1 }
    end

    assert_raises RuntimeError do
      UpAndAtThem::Transaction.new commits
    end
    assert_equal -1, flags[4]
    assert flags[3].to_f < flags[2].to_f
    assert flags[2].to_f < flags[1].to_f
  end

  def test_allow_no_rollback_blocks
    flags = {1 => :pending, 2 => :pending, 3 => :pending, 4 => :pending}

    commits = Array.new
    (1...4).each do |i|
      commits << UpAndAtThem::Commit.new { flags[i] = :committed; if i==3 ; raise 'fail!'; end }
    end

    assert_raises RuntimeError do
      UpAndAtThem::Transaction.new commits
    end
    assert_equal :pending, flags[4]
    assert_equal :committed, flags[3]
    assert_equal :committed, flags[2]
    assert_equal :committed, flags[1]
  end
end