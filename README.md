# Up And At Them!

[![Up And At Them!](http://img.youtube.com/vi/457nGTf4fsQ/0.jpg)](http://www.youtube.com/watch?v=457nGTf4fsQ)

This gem provides a git inmethod for performing atomic transactions with the capability to rollback. Note that this is for
any general Ruby operation and does not replace
[ActiveRecord::Rollback](http://api.rubyonrails.org/classes/ActiveRecord/Rollback.html).

## Installation

Add this line to your application's Gemfile:

    gem 'up_and_at_them'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install up_and_at_them

## Usage

Create a Transaction which contains all of your commits. Note that the Transaction will run as soon as it is
initialized.

    UpAndAtThem::Transaction.new commits
        UpAndAtThem::Commit.new { flags[i] = :committed; if i==3 ; raise 'uh oh!'; end }.on_rollback { flags[i] = :rolled_back }

See the tests for other example Commit actions within a Transaction.

## Contributing

1. Fork it ( https://github.com/metova/up_and_at_them/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
