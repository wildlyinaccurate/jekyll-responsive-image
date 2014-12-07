module Jekyll
  class ResponsiveImage
    class Block < Liquid::Block
      include ResponsiveImage::Utils

      def render(context)
        config = ResponsiveImage.defaults.dup
        config.merge!(context.registers[:site].config['responsive_image'])

        attributes = YAML.load(super)
        image_template = attributes['template'] || config['template']

        resize_handler = ResizeHandler.new
        img = Magick::Image::read(attributes['path']).first
        attributes['original'] = image_hash(attributes['path'], img.columns, img.rows)
        attributes['resized'] = resize_handler.resize_image(img, config)

        partial = File.read(image_template)
        template = Liquid::Template.parse(partial)

        template.render!(attributes)
      end
    end
  end
end
