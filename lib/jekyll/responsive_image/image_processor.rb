module Jekyll
  class ResponsiveImage
    class ImageProcessor
      include ResponsiveImage::Utils

      def process(image_path, config)
        raise SyntaxError.new("Invalid image path specified: #{image_path}") unless File.exists?(image_path.to_s)

        resize_handler = ResizeHandler.new
        img = Magick::Image::read(image_path).first

        {
          original: image_hash(config['base_path'], image_path, img.columns, img.rows),
          resized: resize_handler.resize_image(img, config),
        }
      end

      def self.process(image_path, config)
        self.new.process(image_path, config)
      end
    end
  end
end
