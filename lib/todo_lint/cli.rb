module TodoLint
  # Here we bring together all the pieces and see if it comes together
  # TODO: test this class somehow
  class Cli
    # Startup the thing that actually checks the files for todos!
    # @example
    #   Cli.new([".rb", ".js"])
    # @api public
    def initialize(extensions = [])
      @path = File.expand_path(".")
      @extensions = extensions
    end

    # @example
    #   Cli.new([".rb"]).run!
    # @return exit code 0 for success, 1 for failure
    # @api public
    # rubocop:disable Metrics/AbcSize
    def run! # rubocop:disable Metrics/MethodLength
      finder = FileFinder.new(File.expand_path("."))
      files = finder.list(*extensions)
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

    private

    # Which file extensions are we checking?
    # @return [Array<String>]
    # @api private
    attr_reader :extensions

    # Where are we looking for files?
    # @return [String]
    # @api private
    attr_reader :path

    # Pluralize a word based on the count
    # @return [String]
    # @api private
    def pluralize(word, count)
      s = count == 1 ? "" : "s"
      "#{count} #{word + s}"
    end
  end
end
