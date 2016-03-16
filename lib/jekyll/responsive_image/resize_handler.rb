module Jekyll
  class ResponsiveImage
    class ResizeHandler
      include ResponsiveImage::Utils

      def resize_image(img, config)
        resized = []

        config['sizes'].each do |size|
          width = size['width']
          ratio = width.to_f / img.columns.to_f
          height = (img.rows.to_f * ratio).round

          next unless needs_resizing?(img, width)

          filepath = format_output_path(config['output_path_format'], config['base_path'], img.filename, width, height)
          resized.push(image_hash(config['base_path'], filepath, width, height))

          # Don't resize images more than once
          next if File.exists?(filepath)

          ensure_output_dir_exists!(File.dirname(filepath))

          Jekyll.logger.info "Generating #{filepath}"

          i = img.scale(ratio)
          i.write(filepath) do |f|
            f.quality = size['quality'] || config['default_quality']
          end

          # Ensure the generated file is copied to the _site directory
          site_dest_filepath = File.expand_path(filepath, config[:site_dest])
          ensure_output_dir_exists!(File.dirname(site_dest_filepath))
          FileUtils.copy(filepath, site_dest_filepath)

          i.destroy!
        end
        
        img.destroy!

        resized
      end

      def needs_resizing?(img, width)
        img.columns > width
      end

      def ensure_output_dir_exists!(dir)
        unless Dir.exists?(dir)
          Jekyll.logger.info "Creating output directory #{dir}"
          FileUtils.mkdir_p(dir)
        end
      end
    end
  end
end
