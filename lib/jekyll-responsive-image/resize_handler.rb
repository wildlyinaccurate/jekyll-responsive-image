module Jekyll
  module ResponsiveImage
    class ResizeHandler
      include ResponsiveImage::Utils

      attr_reader :original_image

      def initialize(original_image_absolute_path, config)
        @original_image_absolute_path = original_image_absolute_path
        @original_image = Magick::Image::ping(original_image_absolute_path).first
        @original_image_pixels_loaded = false
        @config = config
      end

      def resize_image
        if @config['auto_rotate']
          load_full_image
          @original_image.auto_orient!
        end

        resized = []

        @config['sizes'].each do |size|
          width = size['width']
          ratio = width.to_f / @original_image.columns.to_f
          height = (@original_image.rows.to_f * ratio).round

          next unless needs_resizing?(width)

          image_path = @original_image.filename.force_encoding(Encoding::UTF_8)
          filepath = format_output_path(@config['output_path_format'], @config, image_path, width, height)
          resized.push(image_hash(@config, filepath, width, height))

          site_source_filepath = File.expand_path(filepath, @config[:site_source])
          site_dest_filepath = File.expand_path(filepath, @config[:site_dest])

          if @config['save_to_source']
            target_filepath = site_source_filepath
          else
            target_filepath = site_dest_filepath
          end

          # Don't resize images more than once
          next if File.exist?(target_filepath)

          ensure_output_dir_exists!(target_filepath)
          ensure_output_dir_exists!(site_dest_filepath)

          Jekyll.logger.info "Generating #{target_filepath}"

          load_full_image unless @original_image_pixels_loaded

          if @config['strip']
            @original_image.strip!
          end

          i = @original_image.scale(ratio)

          quality = size['quality'] || @config['default_quality']

          i.write(target_filepath) do |f|
            f.interlace = i.interlace
            f.quality = quality
          end

          if @config['save_to_source']
            # Ensure the generated file is copied to the _site directory
            Jekyll.logger.info "Copying resized image to #{site_dest_filepath}"
            FileUtils.copy_file(site_source_filepath, site_dest_filepath)
          end

          i.destroy!
        end

        @original_image.destroy!

        resized
      end

      def format_output_path(format, config, image_path, width, height)
        params = symbolize_keys(image_hash(config, image_path, width, height))

        Pathname.new(format % params).cleanpath.to_s
      end

      def needs_resizing?(width)
        @original_image.columns > width
      end

      def load_full_image
        @original_image = Magick::Image::read(@original_image_absolute_path).first
        @original_image_pixels_loaded = true
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
