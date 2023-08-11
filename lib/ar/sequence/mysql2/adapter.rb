# frozen_string_literal: true

module AR
  module Sequence
    module Mysql2
      module Adapter
        def check_sequences
          select_all(
            "SHOW  FULL TABLES where Table_type = 'SEQUENCE'"
          ).to_a
        end

        def create_sequence(name, options = {})
          increment = options[:increment] || options[:step]
          name = quote_name(name)

          sql = ["CREATE SEQUENCE IF NOT EXISTS #{name}"]
          sql << "INCREMENT BY #{increment}" if increment
          sql << "START WITH #{options[:start]}" if options[:start]
          sql << ";"

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
          name = quote_column_name(name)
          execute("SELECT nextval(#{name})").first[0]
        end

        # for connection.adapter_name = "PostgreSQL"
        def currval(name)
          name = quote_column_name(name)
          execute("SELECT lastval(#{name})").first[0]
        end

        # for connection.adapter_name = "Mysql2"
        alias lastval currval

        def setval(name, value)
          name = quote_column_name(name)
          execute("SELECT setval(#{name}, #{value})").first[0]
        end
      end
    end
  end
end
