# ar-sequence

[![Tests](https://github.com/fnando/ar-sequence/workflows/Tests/badge.svg)](https://github.com/fnando/ar-sequence)
[![Gem](https://img.shields.io/gem/v/ar-sequence.svg)](https://rubygems.org/gems/ar-sequence)
[![Gem](https://img.shields.io/gem/dt/ar-sequence.svg)](https://rubygems.org/gems/ar-sequence)

Add support for PostgreSQL's `SEQUENCE` on ActiveRecord migrations.

## Installation

```bash
gem install ar-sequence
```

Or add the following line to your project's Gemfile:

```ruby
gem "ar-sequence"
```

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

To define a column that has a sequence as its default value, use something like
the following:

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
# Advance sequence and return new value
ActiveRecord::Base.nextval("position")

# Return value most recently obtained with nextval for specified sequence.
ActiveRecord::Base.currval("position")

# Set sequence's current value
ActiveRecord::Base.setval("position", 1234)
```

## Maintainer

- [Nando Vieira](https://github.com/fnando)

## Contributors

- https://github.com/fnando/ar-sequence/contributors

## Contributing

For more details about how to contribute, please read
https://github.com/fnando/ar-sequence/blob/main/CONTRIBUTING.md.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT). A copy of the license can be
found at https://github.com/fnando/ar-sequence/blob/main/LICENSE.md.

## Code of Conduct

Everyone interacting in the ar-sequence project's codebases, issue trackers,
chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/ar-sequence/blob/main/CODE_OF_CONDUCT.md).
