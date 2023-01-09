# frozen_string_literal: true

require 'dry/transaction'

module TopPop
  module Service
    # service of count player score
    class CountScore
      include Dry::Transaction

      step :count_score

      private

      def count_score(player_answer)
        sort_answer = Service::Sort.new.call
        sort_answer = sort_answer.value!
        videos_id = player_answer.keys
        score = 0
        videos_id.each { |key| score += 20 if sort_answer[key] == player_answer[key].to_i }
        Success(score)
      rescue StandardError
        Failure('Error in counting score; please try again later')
      end
    end
  end
end
