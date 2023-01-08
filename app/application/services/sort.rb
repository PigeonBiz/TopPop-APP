# frozen_string_literal: true

require 'dry/transaction'

module TopPop
  module Service
    class Sort
      include Dry::Transaction

      step :get_all_videos
      step :sort_videos

      private
      
      def get_all_videos()
        get_all_videos = Service::AllVideos.new.call()
        viewable_videos = get_all_videos.value!.videos
        Success(viewable_videos)
      rescue StandardError
        Failure('Cannot get videos right now; please try again later')
      end

      def sort_videos(viewable_videos)
        all_videos = {}
        viewable_videos.each { |video| all_videos.store(video.video_id,video.view_count) } 
        all_videos = all_videos.sort_by {|_key, value| value}.to_h
        sorted_videos = {}
        sorted_videos[all_videos.keys[0]] = 5
        sorted_videos[all_videos.keys[1]] = 4
        sorted_videos[all_videos.keys[2]] = 3
        sorted_videos[all_videos.keys[3]] = 2
        sorted_videos[all_videos.keys[4]] = 1
        Success(sorted_videos)
      rescue StandardError
        Failure('Error in sorting videos; please try again later')
      end
    end
  end
end
