module Jekyll
  class ResponsiveImage
    class Utils
      def self.symbolize_keys(hash)
        result = {}
        hash.each_key do |key|
          result[key.to_sym] = hash[key]
        end
        result
      end
    end
  end
end
