module Jekyll
  module ResponsiveImage
    class Renderer
      include Jekyll::ResponsiveImage::Utils

      def initialize(site, attributes)
        @site = site
        @attributes = attributes
      end

      def make_config
        ResponsiveImage.defaults.dup
                       .merge(@site.config['responsive_image'])
                       .merge(:site_source => @site.source, :site_dest => @site.dest)
      end

      def render_responsive_image
        cache_key = @attributes.to_s
        result = @attributes['cache'] ? RenderCache.get(cache_key) : nil

        if result.nil?
          config = make_config

          absolute_image_path = @site.in_source_dir(@attributes['path'].to_s)
          image = ImageProcessor.process(absolute_image_path, @attributes['path'], config)
          @attributes['original'] = image[:original]
          @attributes['resized'] = image[:resized]

          @attributes['resized'].each { |resized| keep_resized_image!(@site, resized) }

          image_template = @site.in_source_dir(@attributes['template'] || config['template'])
          partial = File.read(image_template)
          template = Liquid::Template.parse(partial)

          result = template.render!(@attributes.merge(@site.site_payload))

          RenderCache.set(cache_key, result)
        end

        result
      end
    end
  end
end
