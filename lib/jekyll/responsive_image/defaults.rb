module Jekyll
  module ResponsiveImage
    @defaults = {
      'default_quality'    => 85,
      'base_path'          => 'assets',
      'output_path_format' => 'assets/resized/%{filename}-%{width}x%{height}.%{extension}',
      'sizes'              => [],
      'extra_images'       => []
    }.freeze

    class << self
      attr_reader :defaults
    end
  end
end
