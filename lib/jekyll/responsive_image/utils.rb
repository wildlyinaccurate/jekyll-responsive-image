require 'pathname'

module Jekyll
  module ResponsiveImage
    module Utils
      def keep_resized_image!(site, image)
        keep_dir = File.dirname(image['path'])
        site.config['keep_files'] << keep_dir unless site.config['keep_files'].include?(keep_dir)
      end

      def symbolize_keys(hash)
        result = {}
        hash.each_key do |key|
          result[key.to_sym] = hash[key]
        end
        result
      end

      # Build a hash containing image information
      def image_hash(config, image_path, width, height)
        {
          'path'      => image_path,
          'dirname'   => relative_dirname(config, image_path),
          'basename'  => File.basename(image_path),
          'filename'  => File.basename(image_path, '.*'),
          'extension' => File.extname(image_path).delete('.'),
          'width'     => width,
          'height'    => height,
        }
      end

      def relative_dirname(config, image_path)
        path = Pathname.new(File.expand_path(image_path, config[:site_source]))
        base = Pathname.new(File.expand_path(config['base_path'], config[:site_source]))

        path.relative_path_from(base).dirname.to_s.delete('.')
      end
    end
  end
end
