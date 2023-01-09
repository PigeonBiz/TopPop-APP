# frozen_string_literal: true

require 'dry-validation'

module TopPop
  module Forms
    # form of player name
    class PlayerName < Dry::Validation::Contract
      REGEX = /^\w+\w$/

      params do
        required(:player_name).filled(:string)
      end

      rule(:player_name) do
        key.failure('Your username is not valid! Please try a different name!') unless REGEX.match?(value)
      end
    end
  end
end
