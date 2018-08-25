module Jekyll
  module ResponsiveImage
    class ImageProcessor
      include ResponsiveImage::Utils

      def self.process(image_path, config)
        self.new.process(image_path, config)
      end

      def process(image_path, config)
        absolute_image_path = File.expand_path(image_path.to_s, config[:site_source])

        raise SyntaxError.new("Invalid image path specified: #{image_path}") unless File.file?(absolute_image_path)

        resize_handler = ResizeHandler.new

        original_image_dimensions = get_dimensions_of_original_image(absolute_image_path, config)

        {
          original: image_hash(config, image_path, original_image_dimensions.first, original_image_dimensions.last),
          resized: resize_handler.resize_image(absolute_image_path, original_image_dimensions, config),
        }
      end

      private

      def get_dimensions_of_original_image(original_image_path, config)
        original_image = FastImage.new(original_image_path)

        # FastImage – opposed to MiniMagick – takes the image's orientation value into consideration by default when returning the size.
        # If one is not using the auto_rotate config setting, this needs to be manually 'uncorrected',
        # so that the resize handler can do its work correctly.
        return original_image.size.reverse if !config['auto_rotate'] && image_is_rotated_90_degrees?(original_image.orientation)

        original_image.size
      end

      def image_is_rotated_90_degrees?(orientation)
        [5,6,7,8].include?(orientation)
      end

    end
  end
end
