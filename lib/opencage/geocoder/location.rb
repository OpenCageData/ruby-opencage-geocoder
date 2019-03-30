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
        @result['geometry']['lat'].to_f
      end

      def lng
        @result['geometry']['lng'].to_f
      end

      def components
        @result['components']
      end

      def annotations
        @result['annotations']
      end

      def confidence
        @result['confidence']
      end
    end
  end
end
