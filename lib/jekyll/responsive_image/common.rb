module Jekyll
  class ResponsiveImage
    module Common
      include Jekyll::ResponsiveImage::Utils

      def make_config(site)
        ResponsiveImage.defaults.dup
                       .merge(site.config['responsive_image'])
                       .merge(:site_source => site.source, :site_dest => site.dest)
      end

      def keep_resized_image!(site, image)
        keep_dir = File.dirname(image['path'])
        site.config['keep_files'] << keep_dir unless site.config['keep_files'].include?(keep_dir)
      end

      def render_responsive_image(context, attributes)
        cache_key = attributes.to_s
        result = attributes['cache'] ? RenderCache.get(cache_key) : nil

        if result.nil?
          site = context.registers[:site]
          config = make_config(site)

          source_image_path = site.in_source_dir(attributes['path'].to_s)
          image = ImageProcessor.process(source_image_path, config)
          attributes['original'] = image[:original]
          attributes['resized'] = image[:resized]

          attributes['resized'].each { |resized| keep_resized_image!(site, resized) }

          image_template = site.in_source_dir(attributes['template'] || config['template'])
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
