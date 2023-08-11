# frozen_string_literal: true

require "active_support/all"
require "active_record"
require "active_record/connection_adapters/abstract_adapter"
require "active_record/connection_adapters/postgresql_adapter"
require "active_record/connection_adapters/mysql/database_statements"
require "active_record/connection_adapters/mysql2_adapter"
require "active_record/connection_adapters/postgresql/schema_dumper"
require "active_record/migration/command_recorder"
require "active_record/schema_dumper"
require "ar/sequence/version"
require "ar/error"

module AR
  module Sequence
    require "ar/sequence/command_recorder"
    require "ar/sequence/adapter"
    require "ar/sequence/schema_dumper"

    module PostgreSQL
      require "ar/sequence/postgresql/adapter"
    end

    module Mysql2
      require "ar/sequence/mysql2/adapter"
    end
  end
end

ActiveRecord::Migration::CommandRecorder.include(AR::Sequence::CommandRecorder)
ActiveRecord::ConnectionAdapters::AbstractAdapter.include(
  AR::Sequence::Adapter
)
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.include(
  AR::Sequence::PostgreSQL::Adapter
)
ActiveRecord::ConnectionAdapters::Mysql2Adapter.include(
  AR::Sequence::Mysql2::Adapter
)
ActiveRecord::ConnectionAdapters::PostgreSQL::SchemaDumper.prepend(
  AR::Sequence::SchemaDumper
)
