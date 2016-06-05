module Jekyll
  class ResponsiveImage
    class ExtraImageGenerator < Jekyll::Generator
      include Jekyll::ResponsiveImage::Common

      def generate(site)
        config = make_config(site)

        config['extra_images'].each do |pathspec|
          Dir.glob(pathspec) { |path| ImageProcessor.process(path, config) }
        end
      end
    end
  end
end
