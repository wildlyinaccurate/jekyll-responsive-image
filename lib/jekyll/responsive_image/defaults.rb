module Jekyll
  class ResponsiveImage
    @defaults = {
      'default_quality' => 85,
      'output_dir' => 'assets/resized',
      'sizes' => [],
    }.freeze

    class << self
      attr_reader :defaults
    end
  end
end
