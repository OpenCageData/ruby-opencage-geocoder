module OpenCage
  class Geocoder
    class Location
      def initialize(result, _options = {})
        @result = result
      end

      def raw
        @result
      end

      def address
        @result['formatted']
      end

      def coordinates
        [lat, lng]
      end

      def lat
        @result.dig('geometry', 'lat')&.to_f
      end

      alias latitude lat

      def lng
        @result.dig('geometry', 'lng')&.to_f
      end

      alias longitude lng

      def components
        @result['components']
      end

      def annotations
        @result['annotations']
      end

      def confidence
        @result['confidence']
      end

      def bounds
        @result['bounds']
      end
    end
  end
end
