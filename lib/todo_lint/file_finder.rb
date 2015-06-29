require "pathname"

module TodoLint
  # Which files are we going to inspect?
  class FileFinder
    # Instantiate a FileFinder with the path to a folder
    # @example
    #   FileFinder.new("/Users/max/src/layabout")
    # @api public
    def initialize(path)
      @path = path
      @all_files = Dir.glob(Pathname.new(path).join("**", "*"))
    end

    # Absolute paths to all the files with the provided extensions
    # @example
    #   FileFinder.new("/Users/max/src/layabout").list(".rb", ".coffee")
    # @api public
    # @return [Array<String>]
    def list(*extensions)
      all_files.keep_if do |filename|
        extensions.include?(Pathname.new(filename).extname)
      end
    end

    private

    # Which folder to look within for files
    # @return [String]
    # @api private
    attr_reader :path

    # Absolute paths to all the files which exist within the provided folder
    # @return [Array<String>]
    # @api private
    attr_reader :all_files
  end
end
