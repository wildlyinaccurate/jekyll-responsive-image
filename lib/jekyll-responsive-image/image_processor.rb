module Jekyll
  module ResponsiveImage
    class ImageProcessor
      include ResponsiveImage::Utils

      def process(image_path, config)
        absolute_image_path = File.expand_path(image_path.to_s, config[:site_source])

        raise SyntaxError.new("Invalid image path specified: #{image_path}") unless File.file?(absolute_image_path)

        resize_handler = ResizeHandler.new

        original_image_width, original_image_height = ImageSize.path(absolute_image_path).size

        {
          original: image_hash(config, image_path, original_image_width, original_image_height),
          resized: resize_handler.resize_image(absolute_image_path, config),
        }
      end

      def self.process(image_path, config)
        self.new.process(image_path, config)
      end
    end
  end
end
