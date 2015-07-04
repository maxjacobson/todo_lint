require "optparse"

module TodoLint
  # Handles option parsing for the command line application.
  class Options
    # Parses command line options into an options hash
    # @api public
    # @example Options.new.parse("todo_lint -c app.rb")
    # @param args [Array<String>] arguments passed via the command line
    # @return [Hash] parsed options
    def parse(args)
      @options = {}

      OptionParser.new do |parser|
        parser.banner = "Usage: todo_lint [options] [files]"
        add_config_options parser
        exclude_file_options parser
        include_extension_options parser
      end.parse!(args)

      # Any remaining arguments are assumed to be files
      options[:files] = args

      options
    end

    private

    # Adds the file options to the @options hash
    # @api private
    # @return [Hash]
    def add_config_options(parser)
      parser.on("-c", "--config config-file", String,
                "Specify the path to the config file you want
                 to use, from the main repo") do |conf_file|
        options[:config_file] = conf_file
      end
    end

    # Adds the excluded file options to the options hash
    # @api private
    # @return [Hash]
    def exclude_file_options(parser)
      parser.on("-e", "--exclude file1,...", Array,
                "List of file names to exclude") do |files_list|
        options[:excluded_files] = []
        files_list.each do |short_file|
          options[:excluded_files] << File.expand_path(short_file)
        end
      end
    end

    # Adds the include extension options to the @options hash
    # @api private
    # @return [Hash]
    def include_extension_options(parser)
      parser.on("-i", "--include ext1,...", Array,
                "List of extensions to include") do |ext_list|
        options[:extensions] = ext_list
      end
    end

    # Options hash for all configurations
    # @return [Hash]
    # @api private
    attr_reader :options
  end
end
