# frozen_string_literal: true

module AR
  module Sequence
    module PostgreSQL
      module Adapter
        SEQUENCE_COMMENT = "created by ar-sequence"

        def custom_sequence?(sequence_name)
          execute(
            "SELECT obj_description('#{sequence_name}'::regclass, 'pg_class');"
          ).first["obj_description"] == SEQUENCE_COMMENT
        end

        def check_sequences
          select_all(
            "SELECT * FROM information_schema.sequences ORDER BY sequence_name"
          ).to_a
        end

        def create_sequence(name, options = {})
          increment = options[:increment] || options[:step]
          name = quote_name(name)

          sql = ["CREATE SEQUENCE IF NOT EXISTS #{name}"]
          sql << "INCREMENT BY #{increment}" if increment
          sql << "START WITH #{options[:start]}" if options[:start]
          sql << ";"
          sql << "COMMENT ON SEQUENCE #{name} IS '#{SEQUENCE_COMMENT}';"

          execute(sql.join("\n"))
        end

        # Drop a sequence by its name.
        #
        #   drop_sequence :user_position
        #
        def drop_sequence(name)
          name = quote_name(name)
          sql = "DROP SEQUENCE #{name}"
          execute(sql)
        end

        def nextval(name)
          name = quote(name)
          execute("SELECT nextval(#{name})").first["nextval"]
        end

        # for connection.adapter_name = "PostgreSQL"
        def currval(name)
          name = quote(name)
          execute("SELECT currval(#{name})").first["currval"]
        end

        # for connection.adapter_name = "Mysql2"
        alias lastval currval

        def setval(name, value)
          name = quote(name)
          execute("SELECT setval(#{name}, #{value})")
        end
      end
    end
  end
end
