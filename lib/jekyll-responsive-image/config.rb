module Jekyll
  module ResponsiveImage
    class Config
      DEFAULTS = {
        'default_quality'    => 85,
        'base_path'          => 'assets',
        'output_path_format' => 'assets/resized/%{filename}-%{width}x%{height}.%{extension}',
        'sizes'              => [],
        'ignored_extensions' => ['gif'],
        'extra_images'       => [],
        'auto_rotate'        => false,
        'save_to_source'     => true,
        'cache'              => false,
        'strip'              => false
      }

      def initialize(site)
        @site = site
      end

      def valid_config(config)
        config.has_key?('responsive_image') && config['responsive_image'].is_a?(Hash)
      end

      def to_h
        config = {}

        if valid_config(@site.config)
          config = @site.config['responsive_image']
        end


        DEFAULTS.merge(config)
                .merge(site_source: @site.source, site_dest: @site.dest)
      end
    end
  end
end
