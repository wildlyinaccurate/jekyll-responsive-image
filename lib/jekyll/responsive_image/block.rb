module Jekyll
  class ResponsiveImage
    class Block < Liquid::Block
      include Jekyll::ResponsiveImage::Common

      def render(context)
        attributes = YAML.load(super)

        cache_key = attributes.to_s
        result = attributes['cache'] ? RenderCache.get(cache_key) : nil

        if result.nil?
          site = context.registers[:site]
          config = make_config(site)

          image_template = attributes['template'] || config['template']

          image = ImageProcessor.process(attributes['path'], config)
          attributes['original'] = image[:original]
          attributes['resized'] = image[:resized]

          partial = File.read(image_template)
          template = Liquid::Template.parse(partial)

          result = template.render!(attributes.merge(site.site_payload))

          RenderCache.set(cache_key, result)
        end

        result
      end
    end
  end
end
