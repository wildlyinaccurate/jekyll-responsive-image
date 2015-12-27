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

      def format_output_path(format, basepath, path, width, height)
        params = symbolize_keys(image_hash(path, basepath, width, height))
        format % params
      end

      # Build a hash containing image information
      def image_hash(path, basepath, width, height)

        if path.start_with?(basepath)
          folderpath = path.gsub(File.basename(path),"").gsub(basepath,"")
          if folderpath.slice(0) == "/"
            folderpath.slice!(0)
          end
          if folderpath.slice(folderpath.length-1) == "/"
            folderpath.slice!(folderpath.length-1)
          end
          #folderpath = (folderpath.slice(0,-1) == "/") ? folderpath.slice!(0,-1) : folderpath
        else
          folderpath =  ""
        end

        {
          'path'      => path,
          'basename'  => File.basename(path),
          'filename'  => File.basename(path, '.*'),
          'extension' => File.extname(path).delete('.'),
          'width'     => width,
          'height'    => height,
          'folderpath' => folderpath
        }
      end
    end
  end
end
