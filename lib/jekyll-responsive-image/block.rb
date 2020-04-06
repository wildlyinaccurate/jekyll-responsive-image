module Jekyll
  module ResponsiveImage
    class Block < Liquid::Block
      include Jekyll::ResponsiveImage::Utils

      def render(context)
        content = super

        if content.include?("\t")
          content = content.lines.map {|line| line.gsub(/\G[\t ]/, "  ")}.join("\n")
        end

        attributes = YAML.load(content)
        Renderer.new(context.registers[:site], attributes).render_responsive_image
      end
    end
  end
end
