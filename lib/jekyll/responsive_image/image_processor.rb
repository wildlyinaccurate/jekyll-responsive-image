module Jekyll
  module ResponsiveImage
    class ImageProcessor
      include ResponsiveImage::Utils

      def process(absolute_image_path, relative_image_path, config)
        raise SyntaxError.new("Invalid image path specified: #{absolute_image_path}") unless File.file?(absolute_image_path)

        resize_handler = ResizeHandler.new
        img = Magick::Image::read(absolute_image_path).first

        {
          original: image_hash(config['base_path'], relative_image_path, img.columns, img.rows),
          resized: resize_handler.resize_image(img, config),
        }
      end

      def self.process(absolute_image_path, relative_image_path, config)
        self.new.process(absolute_image_path, relative_image_path, config)
      end
    end
  end
end
