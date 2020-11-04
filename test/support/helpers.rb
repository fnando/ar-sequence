# frozen_string_literal: true

module TestHelper
  def recreate_table
    ActiveRecord::Schema.define(version: 0) do
      begin
        drop_table(:things)
      rescue StandardError
        nil
      end
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

  def with_migration(&block)
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
