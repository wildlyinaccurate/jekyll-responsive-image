module Jekyll
  module ResponsiveImage
    class ImageProcessor
      def self.process(path, config)
        self.new.process(path, config)
      end

      def process(path, config)
        raise SyntaxError.new("Invalid image path specified: #{path}") unless File.file?(path)

        image = Magick::Image::read(path).first

        {
          original: Image.new(image.filename, image.columns, image.rows, config),
          resized: ImageResizer.resize(image, config),
        }
      end
    end
  end
end
