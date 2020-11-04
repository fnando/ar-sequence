# frozen_string_literal: true

require "active_record"

ActiveRecord::Base.establish_connection "postgres:///test"
ActiveRecord::Migration.verbose = false
ActiveRecord::Base.logger = nil

class Thing < ActiveRecord::Base
end

class InheritedThing < Thing
end

# Apply a migration directly from your tests:
#
#   test "do something" do
#     schema do
#       drop_table :users if table_exists?(:users)
#
#       create_table :users do |t|
#         t.text :name, null: false
#       end
#     end
#   end
#
def schema(&block)
  ActiveRecord::Schema.define(version: 0, &block)
end

# Create a new migration, which can be executed up and down.
#
#   test "do something" do
#     migration = with_migration do
#       def up
#         # do something
#       end
#
#       def down
#         # undo something
#       end
#     end
#
#     migration.up
#     migration.down
#   end
#
def with_migration(&block)
  migration_class = ActiveRecord::Migration[
    ActiveRecord::Migration.current_version
  ]

  Class.new(migration_class, &block).new
end

def recreate_table
  schema do
    drop_table(:things) if table_exists?(:things)
    execute "drop sequence if exists position"
    execute "drop sequence if exists a"
    execute "drop sequence if exists b"
    execute "drop sequence if exists c"
    execute "drop sequence if exists d"

    create_table :things do |t|
      t.integer :quantity, default: 0
      t.string :slug
    end
  end
end
