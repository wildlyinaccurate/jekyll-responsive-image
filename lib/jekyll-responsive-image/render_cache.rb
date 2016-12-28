module Jekyll
  module ResponsiveImage
    class RenderCache
      attr_accessor :store

      class << self
        def store
          @store ||= {}
        end

        def get(key)
          store[key]
        end

        def set(key, val)
          store[key] = val
        end
      end
    end
  end
end
