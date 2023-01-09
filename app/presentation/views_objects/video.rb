# frozen_string_literal: true

module TopPop
  module Views
    # View for a single video entity
    class Video
      def initialize(video)
        @video = video
      end

      def entity
        @video
      end

      def video_id
        @video.video_id
      end

      def title
        @video.title
      end

      def publish_date
        @video.publish_date
      end

      def channel_title
        @video.channel_title
      end

      def view_count
        @video.view_count
      end
    end
  end
end
