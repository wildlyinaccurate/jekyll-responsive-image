require 'jekyll'
require 'rmagick'

module Jekyll
  class ResponsiveImage
    class Tag < Liquid::Tag
      DEFAULT_QUALITY = 85

      def initialize(tag_name, markup, tokens)
        super

        @attributes = {}
        @markup = markup

        @markup.scan(::Liquid::TagAttributes) do |key, value|
          # Strip quotes from around attribute values
          @attributes[key] = value.gsub(/^['"]|['"]$/, '')
        end
      end

      def resize_image(path, config)
        sizes = config['sizes']

        return if sizes.empty?

        output_dir = config['output_dir']
        ensure_output_dir_exists!(output_dir)

        resized = []
        img = Magick::Image::read(path).first

        sizes.each do |size|
          width = size['width']
          ratio = width.to_f / img.columns.to_f
          height = (img.rows.to_f * ratio).round

          filename = resized_filename(path, width, height)
          newpath = "#{output_dir}/#{filename}"

          next unless needs_resizing?(img, width)

          resized.push({
            'width'  => width,
            'height' => height,
            'path'   => newpath,
          })

          # Don't resize images more than once
          next if File.exists?(newpath)

          Jekyll.logger.info "Generating #{newpath}"

          i = img.scale(ratio)
          i.write(newpath) do |f|
            f.quality = size['quality'] || DEFAULT_QUALITY
          end

          i.destroy!
        end

        resized
      end

      # Insert resize information into a file path
      #
      #   resized_filename(/foo/bar/file.name.jpg, 500, 300)
      #     => /foo/bar/file.name-500x300.jpg
      #
      def resized_filename(path, width, height)
        File.basename(path).sub(/\.([^.]+)$/, "-#{width}x#{height}.\\1")
      end

      def needs_resizing?(img, width)
        img.columns > width
      end

      def ensure_output_dir_exists!(dir)
        unless Dir.exists?(dir)
          Jekyll.logger.info "Creating output directory #{dir}"
          Dir.mkdir(dir)
        end
      end

      def render(context)
        config = context.registers[:site].config['responsive_image']
        config['output_dir'] ||= 'assets/resized'
        config['sizes'] ||= []

        @attributes['resized'] = resize_image(@attributes['path'], config)

        partial = File.read(config['template'])
        template = Liquid::Template.parse(partial)

        template.render!(@attributes)
      end
    end
  end
end

Liquid::Template.register_tag('responsive_image', Jekyll::ResponsiveImage::Tag)
