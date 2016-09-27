module Jekyll
  module ResponsiveImage
    class Config
      DEFAULTS = {
        'default_quality'    => 85,
        'base_path'          => 'assets',
        'output_path_format' => 'assets/resized/%{filename}-%{width}x%{height}.%{extension}',
        'sizes'              => [],
        'extra_images'       => []
      }

      def initialize(site)
        @site = site
      end

      def to_h
        config = DEFAULTS.merge(@site.config['responsive_image'])
                         .merge(site_source: @site.source, site_dest: @site.dest)

         config['base_path'] = @site.in_source_dir(config['base_path'])

         config
      end
    end
  end
end
