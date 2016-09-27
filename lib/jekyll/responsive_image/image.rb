module Jekyll
  module ResponsiveImage
    class Image
      def initialize(width, height, config)
        @width = width
        @height = height
        @config = config
      end

      def to_h
        {
          'path' => '',
          'width' => @width,
          'height' => @height,
          'basename' => '',
          'dirname' => '',
          'filename' => '',
          'extension' => ''
        }
      end

      def to_liquid
        to_h
      end
    end
  end
end
