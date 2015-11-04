module Jekyll
  class ResponsiveImage
    class Block < Liquid::Block
      include Jekyll::ResponsiveImage::Common

      def render(context)
        config = make_config(context.registers[:site])

        attributes = YAML.load(super)
        image_template = attributes['template'] || config['template']

        image = ImageProcessor.process(attributes['path'], config)
        attributes['original'] = image[:original]
        attributes['resized'] = image[:resized]

        partial = File.read(image_template)
        template = Liquid::Template.parse(partial)

        template.render!(attributes)
      end
    end
  end
end
