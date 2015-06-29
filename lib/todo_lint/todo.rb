module TodoLint
  # Todo represents a todo/fixme/etc comment within your source code
  class Todo
    # The regular expression that identifies todo comments
    PATTERN = /
    (?<flag> TODO ){0}
    (?<due_date> \(\d{4}-\d{2}-\d{2}\) ){0}
    \g<flag>\g<due_date>?
    /x

    # Search a file for all of the todo/fixme/etc comments within it
    # @example
    #   Todo.within(File.open("app.rb"))
    # @api public
    # @return [Array<Todo>]
    def self.within(file)
      file.each_line.with_index.map do |line, line_number|
        new(line, :line_number => line_number + 1) if present_in?(line)
      end.compact
    end

    # Does this line contain a todo?
    # @example
    #   Todo.present_in?("hello") #=> false
    #   Todo.present_in?("TODO") #=> true
    # @return [Boolean]
    # @api public
    def self.present_in?(line)
      line =~ PATTERN
    end

    # The content of the line of source code containing the todo comment
    # @example
    #   todo.line #=> "# TODO: refactor me"
    # @api public
    # @return [String]
    attr_reader :line

    # The 1-indexed line on which the todo was discovered
    # @example
    #   todo.line_number #=> 4
    # @api public
    # @return [Fixnum]
    attr_reader :line_number

    # A new Todo must know a few things
    # @example
    #   Todo.new("#TODO: get a boat", line_number: 4)
    # @api public
    def initialize(line, line_number: RequiredArg.new(:line_number))
      absent_todo!(line) unless self.class.present_in?(line)
      @line = line
      @line_number = line_number
    end

    # Was this todo annotated with a due date?
    # @example
    #   annotated_todo.line #=> "# TODO(2013-05-24): learn to fly"
    #   annotated_todo.annotated? #=> true
    #
    #   not_annotated_todo.line #=> "# TODO: read a poem"
    #   not_annotated_todo.annotated? #=> false"
    # @return [Boolean]
    # @api public
    def annotated?
      !match[:due_date].nil?
    end

    # When this todo is due
    # @example
    #   due_todo.line #=> "# TODO(2015-05-24): go to the beach"
    #   due_todo.due_date.to_date #=> #<Date: 2015-05-24>
    #   not_due_todo.line #=> "# TODO: become a fish"
    #   not_due_todo.due_date #=> nil
    # @return [DueDate] if there is a due date
    # @return [NilClass] if there is no due date
    # @api public
    def due_date
      DueDate.from_annotation(match[:due_date]) if annotated?
    end

    # What did the developer write to get our attention?
    # @example
    #   todo.flag #=> "TODO"
    # @return [String]
    # @api public
    def flag
      match[:flag]
    end

    # The 1-indexed character at which the todo comment is found
    # @example
    #   todo.character_number #=> 4
    # @return [Fixnum]
    # @api public
    def character_number
      (line =~ PATTERN) + 1
    end

    private

    # Analyze the line to help identify when the todo is due
    # @return [MatchData]
    # @api private
    def match
      @match ||= PATTERN.match(line)
    end

    # complain that this line isn't even a todo, so nothing will work anyway
    # @return Does not return
    # @api private
    def absent_todo!(line)
      raise ArgumentError, "Not even a todo: #{line.inspect}"
    end
  end
end
