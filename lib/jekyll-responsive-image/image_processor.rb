module Jekyll
  module ResponsiveImage
    class ImageProcessor
      include ResponsiveImage::Utils

      def process(image_path, config)
        absolute_image_path = File.expand_path(image_path.to_s, config[:site_source])

        Jekyll.logger.warn "Invalid image path specified: #{image_path.inspect}" unless File.file?(absolute_image_path)

        resize_handler = ResizeHandler.new(absolute_image_path, config)

        {
          original: image_hash(config, image_path, resize_handler.original_image.columns, resize_handler.original_image.rows),
          resized: resize_handler.resize_image,
        }
      end

      def self.process(image_path, config)
        self.new.process(image_path, config)
      end
    end
  end
end
