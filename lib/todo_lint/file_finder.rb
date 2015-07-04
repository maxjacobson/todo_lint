require "pathname"

module TodoLint
  # Which files are we going to inspect?
  class FileFinder
    # Instantiate a FileFinder with the path to a folder
    # @example
    #   FileFinder.new("/Users/max/src/layabout")
    # @api public
    def initialize(path, options)
      @path = path
      @options = options
      @all_files = Dir.glob(Pathname.new(path).join("**", "*"))
      @excluded = options[:excluded_files]
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
      all_files.reject! { |file| excluded_file?(file) }
      all_files
    end

    # Options hash for all configurations
    # @return [Hash]
    # @example FileFinder.new(path, options).options
    # @api public
    attr_reader :options

    private

    # Which folder to look within for files
    # @return [String]
    # @api private
    attr_reader :path

    # Absolute paths to all the files which exist within the provided folder
    # @return [Array<String>]
    # @api private
    attr_reader :all_files

    # Check if this file has been excluded
    # @api private
    # @return [Boolean]
    def excluded_file?(file)
      full_path = File.expand_path(file)
      options.fetch(:excluded_files, []).any? do |file_to_exclude|
        File.fnmatch(file_to_exclude, full_path)
      end
    end
  end
end
