# AR::Sequence

[![Travis-CI](https://travis-ci.org/fnando/ar-sequence.png)](https://travis-ci.org/fnando/ar-sequence)
[![Code Climate](https://codeclimate.com/github/fnando/ar-sequence/badges/gpa.svg)](https://codeclimate.com/github/fnando/ar-sequence)
[![Test Coverage](https://codeclimate.com/github/fnando/ar-sequence/badges/coverage.svg)](https://codeclimate.com/github/fnando/ar-sequence/coverage)
[![Gem](https://img.shields.io/gem/v/ar-sequence.svg)](https://rubygems.org/gems/ar-sequence)
[![Gem](https://img.shields.io/gem/dt/ar-sequence.svg)](https://rubygems.org/gems/ar-sequence)

Add support for PostgreSQL's SEQUENCE on ActiveRecord migrations.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "ar-sequence"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ar-sequence

## Usage

To create a `SEQUENCE`, just use the method `create_sequence`.

```ruby
class CreateUsers < ActiveRecord::Migration[5.2]
  def up
    create_sequence :position
  end

  def down
    drop_sequence :position
  end
end
```

You can also specify the initial value and increment:

```ruby
create_sequence :position, increment: 2
create_sequence :position, start: 100
```

To define a column that has a sequence as its default value, use something like the following:

```ruby
class CreateThings < ActiveRecord::Migration[5.2]
  def change
    create_sequence :position

    create_table :things do |t|
      t.text :name

      # PostgreSQL uses bigint as the sequence's default type.
      # Use a block to specify the default value on migrations.
      t.bigint :position,
                null: false,
                default: -> { "nextval('position')" }

      t.timestamps
    end
  end
end
```

This gem also adds a few helpers to interact with `SEQUENCE`s.

```ruby
ActiveRecord::Base.nextval("position")       # Advance sequence and return new value
ActiveRecord::Base.currval("position")       # Return value most recently obtained with nextval for specified sequence.
ActiveRecord::Base.setval("position", 1234)  # Set sequence's current value
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fnando/ar-sequence. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

