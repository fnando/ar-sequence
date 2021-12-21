# frozen_string_literal: true

module AR
  module Sequence
    module SchemaDumper
      def header(stream)
        super
        sequences(stream)
      end

      def retrieve_search_path
        user = @connection.select_one("select user").values.first

        @connection
          .select_one("show search_path")
          .values
          .first
          .split(", ")
          .map {|path| path == '"$user"' ? user : path }
      end

      def sequences(stream)
        sequences = @connection.check_sequences
        search_path = retrieve_search_path

        return if sequences.empty?

        sequences.each do |seq|
          schema = seq["sequence_schema"]

          sequence_full_name = [
            search_path.include?(schema) ? nil : schema,
            seq["sequence_name"]
          ].compact.join(".")

          next unless @connection.custom_sequence?(sequence_full_name)

          start_value = seq["start_value"]
          increment = seq["increment"]

          options = []

          if start_value && Integer(start_value) != 1
            options << "start: #{start_value}"
          end

          if increment && Integer(increment) != 1
            options << "increment: #{increment}"
          end

          statement = [
            "create_sequence",
            sequence_full_name.inspect
          ].join(" ")

          if options.any?
            statement << (options.any? ? ", #{options.join(', ')}" : "")
          end

          stream.puts "  #{statement}"
        end

        stream.puts
      end
    end
  end
end
