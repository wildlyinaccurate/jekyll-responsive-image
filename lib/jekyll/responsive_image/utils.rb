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

      def format_output_path(format, path, width, height)
        params = symbolize_keys(image_hash(path, width, height))
        format % params
      end

      # Build a hash containing image information
      def image_hash(path, width, height)
        {
          'path'      => path,
          'dirname'   => File.dirname(path),
          'basename'  => File.basename(path),
          'filename'  => File.basename(path, '.*'),
          'extension' => File.extname(path).delete('.'),
          'width'     => width,
          'height'    => height,
        }
      end
    end
  end
end
