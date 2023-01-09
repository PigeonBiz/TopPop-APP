# frozen_string_literal: true

require 'dry/transaction'

module TopPop
  module Service
    # service of get all videos
    class AllVideos
      include Dry::Transaction

      step :get_all_videos
      step :reify_videos

      private

      def get_all_videos
        result_videos = Gateway::Api.new(TopPop::App.config)
                                    .get_all_videos
        result_videos.success? ? Success(result_videos.payload) : Failure(result_videos.message)
      rescue StandardError => e
        puts e.inspect
        puts e.backtrace
        Failure('Cannot get videos right now; please try again later')
      end

      def reify_videos(videos_json)
        Representer::Videos.new(OpenStruct.new)
                           .from_json(videos_json)
                           .then { |videos| Success(videos) }
      rescue StandardError
        Failure('Error in parsing videos; please try again later')
      end
    end
  end
end
