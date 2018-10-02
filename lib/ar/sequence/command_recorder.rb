module AR
  module Sequence
    module CommandRecorder
      # Usage:
      #
      #   create_sequence :user_position
      #
      def create_sequence(name, options = {})
        record(__method__, [name, options])
      end

      # Usage:
      #
      #   drop_sequence :user_position
      #
      def drop_sequence(name)
        record(__method__, [name])
      end

      def invert_create_sequence(args)
        name, _ = args
        [:drop_sequence, [name]]
      end
    end
  end
end
