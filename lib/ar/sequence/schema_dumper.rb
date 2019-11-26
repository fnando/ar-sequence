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
          start_value = seq["start_value"]
          increment = seq["increment"]

          options = []
          options << "start: #{start_value}" if start_value && Integer(start_value) != 1
          options << "increment: #{increment}" if increment && Integer(increment) != 1

          statement = ["create_sequence", seq["sequence_name"].inspect].join(" ")
          statement << (options.any? ? ", #{options.join(', ')}" : "") if options.any?

          stream.puts "  #{statement}"
        end

        stream.puts
      end
    end
  end
end
