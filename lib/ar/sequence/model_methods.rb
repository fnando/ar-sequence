# frozen_string_literal: true

module AR
  module Sequence
    module ModelMethods
      def nextval(name)
        name = connection.quote(name)
        connection.execute("SELECT nextval(#{name})").first["nextval"]
      end

      def currval(name)
        name = connection.quote(name)
        connection.execute("SELECT currval(#{name})").first["currval"]
      end

      def setval(name, value)
        name = connection.quote(name)
        connection.execute("SELECT setval(#{name}, #{value})")
      end
    end
  end
end
