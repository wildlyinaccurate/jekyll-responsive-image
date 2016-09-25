module Jekyll
  class ResponsiveImage
    class ExtraImageGenerator < Jekyll::Generator
      include Jekyll::ResponsiveImage::Common

      def generate(site)
        config = make_config(site)

        config['extra_images'].each do |pathspec|
          Dir.glob(site.in_source_dir(pathspec)) do |path|
            result = ImageProcessor.process(path, config)
            result[:resized].each { |image| keep_resized_image!(site, image) }
          end
        end
      end
    end
  end
end
