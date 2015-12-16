module Jekyll
  class ResponsiveImage
    @defaults = {
      'base_path' => 'assets',
      'default_quality'    => 85,
      'output_path_format' => 'assets/resized/%{filename}-%{width}x%{height}.%{extension}',
      'sizes'              => [],
    }.freeze

    class << self
      attr_reader :defaults
    end
  end
end
