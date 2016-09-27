module Jekyll
  module ResponsiveImage
    class Tag < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        super

        @attributes = {}

        markup.scan(::Liquid::TagAttributes) do |key, value|
          # Strip quotes from around attribute values
          @attributes[key] = value.gsub(/^['"]|['"]$/, '')
        end
      end

      def render(context)
        Renderer.new(context.registers[:site], @attributes).render
      end
    end
  end
end
