# frozen_string_literal: true

module PostgresqlTestHelper
  def recreate_table_in_postgresql
    PostgresqlDB::Schema.define(version: 0) do
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
      execute "drop sequence if exists my_schema.e"

      create_table :things do |t|
        t.integer :quantity, default: 0
        t.string :slug
      end
    end
  end
end
