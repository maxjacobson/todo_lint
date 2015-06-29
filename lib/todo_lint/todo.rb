module TodoLint
  # Todo represents a todo/fixme/etc comment within your source code
  class Todo
    # The regular expression that identifies todo comments
    PATTERN = /TODO/

    # Search a file for all of the todo/fixme/etc comments within it
    # @example
    #   Todo.within(File.open("app.rb"))
    # @api public
    # @return [Array<Todo>]
    def self.within(file)
      file.each_line.with_index.map do |line, line_number|
        if (character_number = line =~ PATTERN)
          new(line, (line_number + 1), (character_number + 1))
        end
      end.compact
    end

    # The content of the line of source code containing the todo comment
    # @example
    #   todo.line #=> "# TODO: refactor me"
    # @api public
    # @return [String]
    attr_reader :line

    # On which line of the file was the todo discovered?
    # @example
    #   todo.line_number #=> 4
    # @api public
    # @return [Fixnum]
    attr_reader :line_number

    # At which character of the line was the todo discovered?
    # @example
    #   todo.character_number #=> 3
    # @api public
    # @return [Fixnum]
    attr_reader :character_number

    # A new Todo must know a few things
    # @example
    #   Todo.new("#TODO: get a boat", 3, 4)
    # @api public
    def initialize(line, line_number, character_number)
      @line = line
      @line_number = line_number
      @character_number = character_number
    end
  end
end
