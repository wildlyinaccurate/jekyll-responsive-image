module Jekyll
  module ResponsiveImage
    class ExtraImageGenerator < Jekyll::Generator
      include Jekyll::ResponsiveImage::Utils
      include FileTest

      def generate(site)
        config = Config.new(site).to_h
        site_source = Pathname.new(site.source)

        config['extra_images'].each do |pathspec|
          Dir.glob(site.in_source_dir(pathspec)) do |image_path|
            if FileTest.file?(image_path)
              path = Pathname.new(image_path)
              relative_image_path = path.relative_path_from(site_source)

              result = ImageProcessor.process(relative_image_path, config)
              result[:resized].each { |image| keep_resized_image!(site, image) }
            end
          end
        end
      end
    end
  end
end
