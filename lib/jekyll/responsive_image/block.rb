module Jekyll
  module ResponsiveImage
    class Block < Liquid::Block
      def render(context)
        attributes = YAML.load(super)
        Renderer.new(context.registers[:site], attributes).render
      end
    end
  end
end
