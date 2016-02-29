require "todo_lint/options"

module TodoLint
  # Here we bring together all the pieces and see if it comes together
  class Cli
    # Startup the thing that actually checks the files for todos!
    # @example
    #   Cli.new(["-i", ".rb,.js"])
    # @api public
    def initialize(args) # rubocop:disable
      @options = Options.new.parse(args)
      if @options[:config_file]
        @options.merge!(ConfigFile.new.read_config_file(@options[:config_file]))
      elsif File.exist?("./.todo_lint.yml")
        @options.merge!(ConfigFile.new.read_config_file("./.todo_lint.yml"))
      end
      @path = File.expand_path(".")
      add_default_extensions unless @options.fetch(:files) { [] }.any?
    end

    # Perform the actions requested based on the options specified
    #
    # @example
    #   Cli.new(["-i", ".rb"]).run!
    # @return exit code 0 for success, 1 for failure
    # @api public
    def run!
      if options[:report]
        print_report
      else
        lint_codebase
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
        file_finder.options.fetch(:files) { [] }
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

    # Check requested files for problematic TODO comments
    # @return exit code 0 for success, 1 for failure
    # @api private
    def lint_codebase
      finder = FileFinder.new(path, options)
      files = load_files(finder)
      files_count = files.count
      reports = files.map do |file|
        Todo.within(File.open(file), :config => @options).map do |todo|
          reporter = Reporter.new(todo,
                                  :judge => Judge.new(todo))
          reporter.report.tap do |report|
            print Rainbow(".").public_send(report.nil? ? :green : :red)
          end
        end
      end.flatten.compact
      if reports.any?
        puts
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

    # Print report of todos in codebase, then exit
    #
    # @return by exiting with 0
    # @api private
    def print_report
      todos = []
      finder = FileFinder.new(path, options)
      files = load_files(finder)
      files.each do |file|
        todos += Todo.within(File.open(file), :config => @options)
      end
      todos.sort.each.with_index do |todo, num|
        due_date = if todo.due_date
                     tag_context = " via #{todo.tag}" if todo.tag?
                     Rainbow(" (due #{todo.due_date.to_date}#{tag_context})")
                       .public_send(todo.due_date.overdue? ? :red : :blue)
                   else
                     Rainbow(" (no due date)").red
                   end
        puts "#{num + 1}. #{todo.task}#{due_date} " +
             Rainbow(
               "(#{todo.relative_path}:#{todo.line_number}:" \
               "#{todo.character_number})"
             ).yellow
      end

      exit 0
    end

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
