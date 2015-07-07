require "todo_lint/options"

module TodoLint
  # Here we bring together all the pieces and see if it comes together
  class Cli
    # Startup the thing that actually checks the files for todos!
    # @example
    #   Cli.new(["-i", ".rb,.js"])
    # @api public
    def initialize(args) # rubocop:disable Metrics/AbcSize
      @options = Options.new.parse(args)
      if @options[:config_file]
        @options.merge!(ConfigFile.new.read_config_file(@options[:config_file]))
      elsif File.exist?("./.todo_lint.yml")
        @options.merge!(ConfigFile.new.read_config_file("./.todo_lint.yml"))
      end
      @path = File.expand_path(".")
      add_default_extensions unless @options.fetch(:files, []).any?
    end

    # @example
    #   Cli.new(["-i", ".rb"]).run!
    # @return exit code 0 for success, 1 for failure
    # @api public
    # rubocop:disable Metrics/AbcSize
    def run! # rubocop:disable Metrics/MethodLength
      finder = FileFinder.new(path, options)
      files = load_files(finder)
      files_count = files.count
      reports = files.map do |file|
        Todo.within(File.open(file)).map do |todo|
          reporter = Reporter.new(todo,
                                  :path => file,
                                  :judge => Judge.new(todo))
          reporter.report.tap do |report|
            print Rainbow(".").public_send(report.nil? ? :green : :red)
          end
        end
      end.flatten.compact
      if reports.any?
        reports.each do |report|
          puts report
        end
        puts "\nFound #{pluralize('problematic todo', reports.count)} in " \
          "#{pluralize('file', files_count)}"
        exit 1
      else
        puts "\nGreat job! No overdue todos in " \
             "#{pluralize('file', files_count)}"
        exit 0
      end
    end

    # Loads the files to be read
    # @return [Array<String>]
    # @example cli.load_files(file_finder)
    # @api public
    def load_files(file_finder)
      if file_finder.options.fetch(:files).empty?
        file_finder.list(*options[:extensions])
      else
        file_finder.options.fetch(:files, [])
      end
    end

    private

    # Where are we looking for files?
    # @return [String]
    # @api private
    attr_reader :path

    # Options hash for all configurations
    # @return [Hash]
    # @api private
    attr_reader :options

    # Pluralize a word based on the count
    # @return [String]
    # @api private
    def pluralize(word, count)
      s = count == 1 ? "" : "s"
      "#{count} #{word + s}"
    end

    # Set default extensions if none given
    # @api private
    # @return [Array<String>]
    def add_default_extensions
      return if options[:extensions]
      options[:extensions] = [".rb"]
    end
  end
end
