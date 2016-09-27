require 'pathname'

module Jekyll
  module ResponsiveImage
    class Image
      def initialize(path, width, height, config)
        @path = path.force_encoding(Encoding::UTF_8)
        @width = width
        @height = height
        @config = config
      end

      # The directory name, relative to base_path
      def dirname
        base_path = Pathname.new(File.join(@config[:site_source], @config['base_path']))
        image_path = Pathname.new(File.join(@config[:site_source], @path))

        image_path.relative_path_from(base_path).dirname.to_s.delete('.')
      end

      def to_h
        {
          'basename'  => File.basename(@path),
          'dirname'   => dirname,
          'extension' => File.extname(@path).delete('.'),
          'filename'  => File.basename(@path, '.*'),
          'height'    => @height,
          'path'      => @path,
          'width'     => @width
        }
      end

      def to_liquid
        to_h
      end
    end
  end
end
