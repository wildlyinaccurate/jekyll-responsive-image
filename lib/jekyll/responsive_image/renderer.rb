module Jekyll
  module ResponsiveImage
    class Renderer
      attr_reader :site, :attributes

      def initialize(site, attributes)
        @site = site
        @attributes = attributes
      end

      def render
        cache_key = attributes.to_s
        result = attributes['cache'] ? RenderCache.get(cache_key) : nil

        if result.nil?
          config = Config.new(site).to_h

          image = ImageProcessor.process(attributes['path'], config)
          template_vars = attributes.merge(site.site_payload)
                                    .merge('original' => image[:original], 'resized' => image[:resized])

          image_template = site.in_source_dir(attributes['template'] || config['template'])
          template = Liquid::Template.parse(File.read(image_template))
          result = template.render(template_vars)

          RenderCache.set(cache_key, result)
        end

        result
      end
    end
  end
end
