module Jekyll
  module ResponsiveImage
    class ImageResizer
      def self.resize(image, config)
        self.new.resize(image, config)
      end

      def resize(image, config)
        results = []

        config['sizes'].each do |size|
          width = size['width']
          ratio = width.to_f / image.columns.to_f
          height = (image.rows.to_f * ratio).round

          next unless needs_resizing?(image, width)

          image_path = image.filename
          source_img = Image.new(image_path, width, height, config)
          site_source_path = format_output_path(config['output_path_format'], source_img.to_h)

          resized_img = Image.new(site_source_path, width, height, config)
          results.push(resized_img)

          # Don't resize images more than once
          next if File.exist?(site_source_path)

          site_dest_path = File.join(config[:site_dest], site_source_path)
          ensure_output_dir_exists!(site_source_path)
          ensure_output_dir_exists!(site_dest_path)

          Jekyll.logger.info "Generating #{site_source_path}"

          resized = image.scale(ratio)
          resized.write(site_source_path) do |i|
            i.quality = size['quality'] || config['default_quality']
          end

          # Ensure the generated file is copied to the _site directory
          Jekyll.logger.info "Copying image to #{site_dest_path}"
          FileUtils.copy_file(site_source_path, site_dest_path)
        end

        results
      end

      def format_output_path(format, image_hash)
        params = symbolize_keys(image_hash)

        Pathname.new(format % params).cleanpath.to_s
      end

      def symbolize_keys(hash)
        hash.each_with_object({}){ |(key, val), h| h[key.to_sym] = val }
      end

      def needs_resizing?(image, width)
        image.columns > width
      end

      def ensure_output_dir_exists!(path)
        dir = File.dirname(path)

        unless Dir.exist?(dir)
          Jekyll.logger.info "Creating output directory #{dir}"
          FileUtils.mkdir_p(dir)
        end
      end
    end
  end
end
