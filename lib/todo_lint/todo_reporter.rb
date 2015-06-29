module TodoLint
  # We want to be able to report to users about the todos in their code, and
  # the TodoReporter is responsible for passing judgment and generating output
  class TodoReporter
    # Accept a todo and a path to check for problems
    # @example
    #   TodoReporter.new(todo, path: "/Users/max/src/required_arg/README.md")
    # @api public
    def initialize(todo, path: RequiredArg.new(:path))
      @todo = todo
      @path = path
    end

    # Generate the output to show the user about their todo
    # @example
    #   reporter.report
    # @return [String] if the todo is problematic
    # @return [NilClass] if the todo is fine
    # @api public
    def report
      return unless problematic?

      "#{problem_location} #{problem}\n" \
      "#{todo.line}\n" \
      "#{spaces}#{carets}"
    end

    private

    # The todo being reported on
    # @return [Todo]
    # @api private
    attr_reader :todo

    # The path to the file containing the todo
    # @return [String]
    # @api private
    attr_reader :path

    # Whether we need to report on this todo or not
    # @return [Boolean]
    # @api private
    def problematic?
      !todo.annotated?
    end

    def problem_location
      Rainbow(path).green + ":#{todo.line_number}:#{todo.character_number}"
    end

    # The reason we are reporting on this todo
    # @return [String]
    # @api private
    def problem
      Rainbow("Missing due date annotation").red
    end

    # Generate the indentation before the carets
    # @return [String]
    # @api private
    def spaces
      " " * (todo.character_number - 1)
    end

    # Generate the ^^^^ characters to point at the flag
    # @return [String]
    # @api private
    def carets
      "^" * (todo.flag.length)
    end
  end
end
