require 'pathname'

module Jekyll
  class ResponsiveImage
    module Utils
      def symbolize_keys(hash)
        result = {}
        hash.each_key do |key|
          result[key.to_sym] = hash[key]
        end
        result
      end

      def format_output_path(format, base_path, image_path, width, height)
        params = symbolize_keys(image_hash(base_path, image_path, width, height))

        Pathname.new(format % params).cleanpath.to_s
      end

      # Build a hash containing image information
      def image_hash(base_path, image_path, width, height)
        {
          'path'      => image_path,
          'dirname'   => relative_dirname(base_path, image_path),
          'basename'  => File.basename(image_path),
          'filename'  => File.basename(image_path, '.*'),
          'extension' => File.extname(image_path).delete('.'),
          'width'     => width,
          'height'    => height,
        }
      end

      def relative_dirname(base_path, image_path)
        path = Pathname.new(image_path).expand_path
        base = Pathname.new(base_path).expand_path

        path.relative_path_from(base).dirname.to_s.delete('.')
      end
    end
  end
end
