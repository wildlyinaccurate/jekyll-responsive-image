module Jekyll
  module ResponsiveImage
    class ExtraImageGenerator < Jekyll::Generator
      include Jekyll::ResponsiveImage::Utils

      def generate(site)
        renderer = Renderer.new(site, {})
        config = renderer.make_config

        config['extra_images'].each do |pathspec|
          Dir.glob(site.in_source_dir(pathspec)) do |image_path|
            relative_image_path = image_path.sub(/^#{Regexp.escape(image_path)}/, '')

            result = ImageProcessor.process(image_path, relative_image_path, config)
            result[:resized].each { |image| keep_resized_image!(site, image) }
          end
        end
      end
    end
  end
end
