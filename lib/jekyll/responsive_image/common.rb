module Jekyll
  class ResponsiveImage
    module Common
      include Jekyll::ResponsiveImage::Utils

      def make_config(site)
        config = ResponsiveImage.defaults.dup.merge(site.config['responsive_image']).merge(:site_dest => site.dest)

        # Not very nice, but this is needed to create a clean path to add to keep_files
        output_dir = config['output_path_format'].slice(0, config['output_path_format'].index('%') - 1)
        site.config['keep_files'] << output_dir unless site.config['keep_files'].include?(output_dir)

        config
      end
    end
  end
end
