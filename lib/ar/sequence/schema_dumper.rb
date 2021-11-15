# frozen_string_literal: true

module AR
  module Sequence
    module SchemaDumper
      def header(stream)
        super
        sequences(stream)
      end

      def sequences(stream)
        sequences = @connection.check_sequences
        return if sequences.empty?

        sequences.each do |seq|
          sequence_full_name = [seq["sequence_schema"], seq["sequence_name"]].join(".")
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
