# Up And At Them!

[![Up And At Them!](http://img.youtube.com/vi/457nGTf4fsQ/0.jpg)](http://www.youtube.com/watch?v=457nGTf4fsQ)

This gem provides a method for performing atomic transactions with the capability to rollback. Note that this is for
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

    UpAndAtThem::Transaction[
      UpAndAtThem::Commit.new { puts "do something!" }.on_rollback { "undo something!" },
      UpAndAtThem::Commit.new { puts "do something else!" }.on_rollback { "undo something else!" }
    ]

The `UpAndAtThem::Transaction` array can contain any classes that respond to `#call` and `#rollback`. The
`UpAndAtThem::Commit` class allows you to define those methods easily:

    UpAndAtThem::Commit.new { "this block will execute on #call" }.on_rollback { "this block will execute on #rollback" }
    UpAndAtThem::Commit.new { "calling on_rollback is not necessary" }

See the tests for other example Commit actions within a Transaction.

## Contributing

1. Fork it ( https://github.com/metova/up_and_at_them/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
