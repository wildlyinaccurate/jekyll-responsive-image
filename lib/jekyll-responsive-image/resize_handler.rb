module Jekyll
  module ResponsiveImage
    class ResizeHandler
      include ResponsiveImage::Utils

      def resize_image(original_image_path, config)
        resized = []

        config['sizes'].each do |size|
          original_image_copy = MiniMagick::Image.open(original_image_path)
          original_image_copy.auto_orient if config['auto_rotate']

          new_width                = size['width']
          downsize_factor = new_width.to_f / original_image_copy.width.to_f
          new_height               = (original_image_copy.height.to_f * downsize_factor).round

          next unless needs_resizing?(original_image_copy, new_width)

          image_path = original_image_path.force_encoding(Encoding::UTF_8)
          filepath = format_output_path(config['output_path_format'], config, image_path, new_width, new_height)
          resized.push(image_hash(config, filepath, new_width, new_height))

          site_source_filepath = File.expand_path(filepath, config[:site_source])
          site_dest_filepath = File.expand_path(filepath, config[:site_dest])

          if config['save_to_source']
            target_filepath = site_source_filepath
          else
            target_filepath = site_dest_filepath
          end

          # Don't resize images more than once
          next if File.exist?(target_filepath)

          ensure_output_dir_exists!(target_filepath)
          ensure_output_dir_exists!(site_dest_filepath)

          Jekyll.logger.info "Generating #{target_filepath}"

          original_image_copy.combine_options do |image|
            image.resize "#{new_width}"
            image.quality "#{size['quality'] || config['default_quality']}"
            image.interlace original_image_copy.data["interlace"]
            image.strip if config['strip']
          end

          original_image_copy.write(target_filepath)

          if config['save_to_source']
            # Ensure the generated file is copied to the _site directory
            Jekyll.logger.info "Copying resized image to #{site_dest_filepath}"
            FileUtils.copy_file(site_source_filepath, site_dest_filepath)
          end

          original_image_copy.destroy!
        end

        resized
      end

      def format_output_path(format, config, image_path, width, height)
        params = symbolize_keys(image_hash(config, image_path, width, height))

        Pathname.new(format % params).cleanpath.to_s
      end

      def needs_resizing?(img, width)
        img.width > width
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
