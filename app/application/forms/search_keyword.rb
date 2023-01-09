# frozen_string_literal: true

require 'dry-validation'

module TopPop
  module Forms
    # form of search keyword
    class SearchKeyword < Dry::Validation::Contract
      REGEX = /[^<>]/

      params do
        required(:search_keyword).filled(:string)
      end

      rule(:search_keyword) do
        key.failure('Search keyword is not valid! Please try a different keyword!') unless REGEX.match?(value)
      end
    end
  end
end
