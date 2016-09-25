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
        render_responsive_image(context, @attributes)
      end
    end
  end
end
