# frozen_string_literal: true

module MysqlTestHelper
  def recreate_table_in_mysql
    MysqlDB::Schema.define(version: 0) do
      begin
        drop_table(:wares)
      rescue StandardError
        nil
      end
      execute "drop sequence if exists position"
      execute "drop sequence if exists a"
      execute "drop sequence if exists b"
      execute "drop sequence if exists c"
      execute "drop sequence if exists d"
      execute "drop sequence if exists my_schema.e"

      create_table :wares do |t|
        t.integer :quantity, default: 0
        t.string :slug
      end
    end
  end
end
