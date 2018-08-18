module Jekyll
  module ResponsiveImage
    class ImageProcessor
      include ResponsiveImage::Utils

      def process(image_path, config)
        absolute_image_path = File.expand_path(image_path.to_s, config[:site_source])

        raise SyntaxError.new("Invalid image path specified: #{image_path}") unless File.file?(absolute_image_path)

        resize_handler = ResizeHandler.new

        original_image_width, original_image_height = get_dimensions_of_original(absolute_image_path)

        {
          original: image_hash(config, image_path, original_image_width, original_image_height),
          resized: resize_handler.resize_image(absolute_image_path, config),
        }
      end

      def get_dimensions_of_original(absolute_image_path)
        original_image_copy = MiniMagick::Image.open(absolute_image_path)
        dimensions          = original_image_copy.dimensions

        original_image_copy.destroy!

        dimensions
      end

      def self.process(image_path, config)
        self.new.process(image_path, config)
      end
    end
  end
end
