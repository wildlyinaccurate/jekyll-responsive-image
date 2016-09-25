








module Jekyll
  class ResponsiveImage
    class Block < Liquid::Block
      include Jekyll::ResponsiveImage::Common

      def render(context)
        attributes = YAML.load(super)
        render_responsive_image(context, attributes)
      end
    end
  end
end
