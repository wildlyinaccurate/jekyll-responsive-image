module Jekyll
  module ResponsiveImage
    class ResizeHandler
      include ResponsiveImage::Utils

      def resize_image(img, config)
        resized = []

        config['sizes'].each do |size|
          width = size['width']
          ratio = width.to_f / img.columns.to_f
          height = (img.rows.to_f * ratio).round

          next unless needs_resizing?(img, width)

          image_path = img.filename.force_encoding(Encoding::UTF_8)
          filepath = format_output_path(config['output_path_format'], config, image_path, width, height)
          resized.push(image_hash(config, filepath, width, height))

          site_source_filepath = File.expand_path(filepath, config[:site_source])
          site_dest_filepath = File.expand_path(filepath, config[:site_dest])

          # Don't resize images more than once
          next if File.exist?(site_source_filepath)

          ensure_output_dir_exists!(site_source_filepath)
          ensure_output_dir_exists!(site_dest_filepath)

          Jekyll.logger.info "Generating #{site_source_filepath}"

          i = img.scale(ratio)
          i.write(site_source_filepath) do |f|
            f.quality = size['quality'] || config['default_quality']
          end

          # Ensure the generated file is copied to the _site directory
          Jekyll.logger.info "Copying resized image to #{site_dest_filepath}"
          FileUtils.copy_file(site_source_filepath, site_dest_filepath)

          i.destroy!
        end

        img.destroy!

        resized
      end

      def format_output_path(format, config, image_path, width, height)
        params = symbolize_keys(image_hash(config, image_path, width, height))

        Pathname.new(format % params).cleanpath.to_s
      end

      def needs_resizing?(img, width)
        img.columns > width
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
