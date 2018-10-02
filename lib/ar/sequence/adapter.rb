module AR
  module Sequence
    module Adapter
      def check_sequences
        select_all("SELECT * FROM information_schema.sequences").to_a
      end

      def create_sequence(name, options = {})
        increment = options[:increment] || options[:step]
        name = quote_column_name(name)

        sql = ["CREATE SEQUENCE IF NOT EXISTS #{name}"]
        sql << "INCREMENT BY #{increment}" if increment
        sql << "START WITH #{options[:start]}" if options[:start]

        execute(sql.join("\n"))
      end

      # Drop a sequence by its name.
      #
      #   drop_sequence :user_position
      #
      def drop_sequence(name)
        name = quote_column_name(name)
        sql = "DROP SEQUENCE #{name}"
        execute(sql)
      end
    end
  end
end
