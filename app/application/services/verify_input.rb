# frozen_string_literal: true

require 'dry/transaction'

module TopPop
  module Service
    # Start to play game
    class VerifyInput
      include Dry::Transaction

      step :verify_input

      private

      def verify_input(player_name)
        if player_name.success?
          Success(player_name)
        else
          Failure(player_name.errors.messages.first.to_s)
        end
      end
    end
  end
end
