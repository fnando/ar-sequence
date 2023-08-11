# frozen_string_literal: true

module AR
  class MethodNotAllowed < StandardError
    METHOD_NOT_ALLOWED = "Method not allowed"

    # Initialize a new Error object
    def initialize(message = "")
      super(message)
    end
  end
end
