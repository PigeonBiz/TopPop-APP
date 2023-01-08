# frozen_string_literal: true

module TopPop
  module Views
    # Parse view count to readable format
    module ParseView
      def self.call(view_count)
        raw_viewcount = view_count.to_f
        viewcount_billion = raw_viewcount/1000000000
        viewcount_million = raw_viewcount/1000000
        if (viewcount_billion > 1)
          "#{viewcount_billion.round(2)}B"
        else
          "#{viewcount_million.round(1)}M"
        end
      end
    end
  end
end
