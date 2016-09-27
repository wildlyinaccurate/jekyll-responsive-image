module Jekyll
  module ResponsiveImage
    class ImageResizer
      def self.resize(image, config)
        self.new.resize(image, config)
      end

      def resize(image, config)
        resized = []

        config['sizes'].each do |size|
          width = size['width']
          ratio = width.to_f / image.columns.to_f
          height = (image.rows.to_f * ratio).round

          next unless needs_resizing?(image, width)

          image_path = image.filename.force_encoding(Encoding::UTF_8)
          output_path = image_path

          resized.push(Image.new(width, height, config))

          # Don't resize images more than once
          next if File.exist?(output_path)

          resized = image.scale(ratio)
          resized.write(output_path) do |i|
            i.quality = size['quality'] || config['default_quality']
          end
        end

        resized
      end

      def needs_resizing?(image, width)
        image.columns > width
      end

      def ensure_output_dir_exists!(dir)
        unless Dir.exist?(dir)
          Jekyll.logger.info "Creating output directory #{dir}"
          FileUtils.mkdir_p(dir)
        end
      end
    end
  end
end
