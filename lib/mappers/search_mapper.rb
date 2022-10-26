# frozen_string_literal: false

require_relative 'video_mapper'

module YoutubeInformation
  module Youtube
    # Data Mapper: Github repo -> Project entity
    class SearchMapper
      def initialize(yt_token, gateway_class = Youtube::Api)
        @yt_token = yt_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@yt_token)
      end

      def search(keyword, count)
        data = @gateway.search_data(keyword, count)
        build_entity(data)
      end

      def build_entity(data)
        DataMapper.new(data).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(data)
          @data = data
        end

        def build_entity
          Entity::Information.new(
            kind:,
            etag:,
            next_page_token:,
            region_code:,
            videos:
          )
        end

        def kind
          @data['kind']
        end

        def etag
          @data['etag']
        end

        def next_page_token
          @data['nextPageToken']
        end

        def region_code
          @data['regionCode']
        end

        def videos
          VideoMapper.new(@data['items']).load_several
        end
      end
    end
  end
end