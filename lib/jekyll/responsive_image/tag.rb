module Jekyll
  class ResponsiveImage
    class Tag < Liquid::Tag
      include Jekyll::ResponsiveImage::Common

      def initialize(tag_name, markup, tokens)
        super

        @attributes = {}

        markup.scan(::Liquid::TagAttributes) do |key, value|
          # Strip quotes from around attribute values
          @attributes[key] = value.gsub(/^['"]|['"]$/, '')
        end
      end

      def render(context)
        cache_key = @attributes.to_s
        result = @attributes['cache'] ? RenderCache.get(cache_key) : nil

        if result.nil?
          site = context.registers[:site]
          config = make_config(site)

          image = ImageProcessor.process(@attributes['path'], config)
          @attributes['original'] = image[:original]
          @attributes['resized'] = image[:resized]

          image_template = @attributes['template'] || config['template']

          partial = File.read(image_template)
          template = Liquid::Template.parse(partial)

          result = template.render!(@attributes.merge(site.site_payload))

          RenderCache.set(cache_key, result)
        end

        result
      end
    end
  end
end
