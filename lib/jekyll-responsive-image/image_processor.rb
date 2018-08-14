module Jekyll
  module ResponsiveImage
    class ImageProcessor
      include ResponsiveImage::Utils

      def process(image_path, config)
        absolute_image_path = File.expand_path(image_path.to_s, config[:site_source])

        raise SyntaxError.new("Invalid image path specified: #{image_path}") unless File.file?(absolute_image_path)

        resize_handler = ResizeHandler.new
        img = Magick::Image::read(absolute_image_path).first

        {
          original: image_hash(config, image_path, img.columns, img.rows),
          resized: resize_handler.resize_image(img, config),
        }
      end

      def self.process(image_path, config)
        begin
          self.new.process(image_path, config)
        rescue SyntaxError
          { original: {}, resized: [] }
        end
      end
    end
  end
end
