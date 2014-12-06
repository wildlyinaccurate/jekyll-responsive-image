module Jekyll
  class ResponsiveImage
    class Tag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        super

        @attributes = {}

        markup.scan(::Liquid::TagAttributes) do |key, value|
          # Strip quotes from around attribute values
          @attributes[key] = value.gsub(/^['"]|['"]$/, '')
        end
      end

      def resize_image(img, config)
        resized = []

        config['sizes'].each do |size|
          width = size['width']
          ratio = width.to_f / img.columns.to_f
          height = (img.rows.to_f * ratio).round

          next unless needs_resizing?(img, width)

          filepath = format_output_path(config['output_path_format'], img.filename, width, height)
          resized.push(image_hash(filepath, width, height))

          # Don't resize images more than once
          next if File.exists?(filepath)

          ensure_output_dir_exists!(File.dirname(filepath))

          Jekyll.logger.info "Generating #{filepath}"

          i = img.scale(ratio)
          i.write(filepath) do |f|
            f.quality = size['quality'] || config['default_quality']
          end

          i.destroy!
        end

        resized
      end

      def format_output_path(format, path, width, height)
        params = Utils.symbolize_keys(image_hash(path, width, height))
        format % params
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

      # Build a hash containing image information
      def image_hash(path, width, height)
        {
          'path'      => path,
          'basename'  => File.basename(path),
          'filename'  => File.basename(path, '.*'),
          'extension' => File.extname(path).delete('.'),
          'width'     => width,
          'height'    => height,
        }
      end

      def render(context)
        config = ResponsiveImage.defaults.dup
        config.merge!(context.registers[:site].config['responsive_image'])

        img = Magick::Image::read(@attributes['path']).first
        @attributes['original'] = image_hash(@attributes['path'], img.columns, img.rows)
        @attributes['resized'] = resize_image(img, config)

        image_template = @attributes['template'] || config['template']

        partial = File.read(image_template)
        template = Liquid::Template.parse(partial)

        template.render!(@attributes)
      end
    end
  end
end
