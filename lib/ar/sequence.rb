require "active_support/all"
require "active_record"
require "active_record/connection_adapters/postgresql_adapter"
require "active_record/connection_adapters/postgresql/schema_dumper"
require "active_record/migration/command_recorder"
require "active_record/schema_dumper"
require "ar/sequence/version"

module AR
  module Sequence
    require "ar/sequence/command_recorder"
    require "ar/sequence/adapter"
    require "ar/sequence/schema_dumper"
    require "ar/sequence/model_methods"
  end
end

ActiveRecord::Migration::CommandRecorder.include AR::Sequence::CommandRecorder
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.include AR::Sequence::Adapter
ActiveRecord::SchemaDumper.prepend AR::Sequence::SchemaDumper
ActiveRecord::Base.extend AR::Sequence::ModelMethods
