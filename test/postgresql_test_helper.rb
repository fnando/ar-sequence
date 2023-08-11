# frozen_string_literal: true

require "test_helper"

ActiveRecord::Base.establish_connection "postgres:///test"
ActiveRecord::Migration.verbose = false

class PostgresqlDB < ActiveRecord::Base
  establish_connection "postgres:///test"

  ActiveRecord::Migration.verbose = false
end

class Thing < ActiveRecord::Base
end

class InheritedThing < Thing
end

module PostgresqlTestHelper
  def recreate_table_in_postgresql
    ActiveRecord::Schema.define(version: 0) do
      drop_table :things, if_exists: true
      execute "drop sequence if exists position"
      execute "drop sequence if exists a"
      execute "drop sequence if exists b"
      execute "drop sequence if exists c"
      execute "drop sequence if exists d"
      execute "drop sequence if exists my_schema.e"
      execute "create schema if not exists my_schema"

      create_table :things do |t|
        t.integer :quantity, default: 0
        t.string :slug
      end
    end
  end

  def postgresql_with_migration(&block)
    migration_class = if ActiveRecord::Migration.respond_to?(:[])
                        ActiveRecord::Migration[
                          ActiveRecord::Migration.current_version
                        ]
                      else
                        ActiveRecord::Migration
                      end

    Class.new(migration_class, &block).new
  end
end
