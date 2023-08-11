# frozen_string_literal: true

module AR
  module Sequence
    module Adapter
      def custom_sequence?(_sequence_name)
        false
      end

      def check_sequences
        []
      end

      def create_sequence(_name, _options = {})
        raise AR::MethodNotAllowed, AR::MethodNotAllowed::METHOD_NOT_ALLOWED
      end

      # Drop a sequence by its name.
      #
      #   drop_sequence :user_position
      #
      def drop_sequence(_name)
        raise AR::MethodNotAllowed, AR::MethodNotAllowed::METHOD_NOT_ALLOWED
      end

      def quote_name(name)
        name.split(".", 2).map {|part| quote_column_name(part) }.join(".")
      end

      def nextval(_name)
        raise AR::MethodNotAllowed, AR::MethodNotAllowed::METHOD_NOT_ALLOWED
      end

      # for connection.adapter_name = "PostgreSQL"
      def currval(_name)
        raise AR::MethodNotAllowed, AR::MethodNotAllowed::METHOD_NOT_ALLOWED
      end

      # for connection.adapter_name = "Mysql2"
      alias lastval currval

      def setval(_name, _value)
        raise AR::MethodNotAllowed, AR::MethodNotAllowed::METHOD_NOT_ALLOWED
      end
    end
  end
end
