module Jekyll
  class ResponsiveImage
    class Tag < Liquid::Tag
      include ResponsiveImage::Utils

      def initialize(tag_name, markup, tokens)
        super

        @attributes = {}

        markup.scan(::Liquid::TagAttributes) do |key, value|
          # Strip quotes from around attribute values
          @attributes[key] = value.gsub(/^['"]|['"]$/, '')
        end
      end

      def render(context)
        config = ResponsiveImage.defaults.dup
        config.merge!(context.registers[:site].config['responsive_image'])

        resize_handler = ResizeHandler.new
        img = Magick::Image::read(@attributes['path']).first
        @attributes['original'] = image_hash(@attributes['path'], img.columns, img.rows)
        @attributes['resized'] = resize_handler.resize_image(img, config)

        image_template = @attributes['template'] || config['template']

        partial = File.read(image_template)
        template = Liquid::Template.parse(partial)

        template.render!(@attributes)
      end
    end
  end
end
