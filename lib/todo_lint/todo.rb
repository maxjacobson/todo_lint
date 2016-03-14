module TodoLint
  # Todo represents a todo/fixme/etc comment within your source code
  class Todo
    # The regular expression that identifies todo comments
    PATTERN = /
    (?<flag> TODO ){0}
    (?<due_date> \(\d{4}-\d{2}-\d{2}\)){0}
    (?<tag>\#\w+){0}
    (?<task>.+?){0}
    \g<flag>: \g<task>(?:\g<due_date>|(?:\(\g<tag>\)))?
    /x

    # Search a file for all of the todo/fixme/etc comments within it
    # @example
    #   Todo.within(File.open("app.rb"))
    # @api public
    # @return [Array<Todo>]
    def self.within(file, config: RequiredArg.new(:config))
      file.each_line.with_index.map do |line, line_number|
        next unless present_in?(line)
        new(
          line,
          :line_number => line_number + 1,
          :path => file.path,
          :config => config
        )
      end.compact
    end

    # Does this line contain a todo?
    # @example
    #   Todo.present_in?("hello") #=> false
    #   Todo.present_in?("TODO") #=> true
    # @return [Boolean]
    # @api public
    def self.present_in?(line)
      line.match(PATTERN) != nil
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

    # The absolute path to the file where we found this todo
    # @example
    #   todo.path #=> "/Users/max/src/layabout/Gemfile"
    #
    # @api public
    # @return [String]
    attr_reader :path

    # A new Todo must know a few things
    # @example
    #   Todo.new("#TODO: get a boat", line_number: 4)
    # @api public
    def initialize(line,
                   line_number: RequiredArg.new(:line_number),
                   path: RequiredArg.new(:path),
                   config: RequiredArg.new(:config))
      absent_todo!(line) unless self.class.present_in?(line)
      @line = line
      @line_number = line_number
      @path = path
      @config = config
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
      !match[:due_date].nil? || !match[:tag].nil?
    end

    # What is the actual task associated with this todo?
    #
    # @example
    #   todo.task #=> "Wash the car"
    #
    # @return [String]
    # @api public
    def task
      match[:task].lstrip
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
      return unless annotated?
      return @due_date if defined?(@due_date)
      @due_date = if match[:due_date]
                    DueDate.from_annotation(match[:due_date])
                  elsif match[:tag]
                    lookup_tag_due_date
                  end
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

    # Was this todo using a tag (as opposed to a direct due date)?
    #
    # @example
    #   todo.tag? #=> true
    # @return [Boolean]
    # @api public
    def tag?
      !match[:tag].nil?
    end

    # What tag does this todo use?
    #
    # @example
    #   todo.tag #=> "#shipit"
    #   todo.tag #=> nil
    #
    # @return [String] if the Todo has a tag
    # @return [NilClass] if the Todo has no tag
    # @api public
    def tag
      match[:tag]
    end

    # Which todo is due sooner?
    #
    # @example
    #   [todo_one, todo_two].sort # this implicitly calls <=>
    #
    # @return [Fixnum]
    # @api public
    def <=>(other)
      due_date_for_sorting <=> other.due_date_for_sorting
    end

    # The relative path to the file where this todo was found
    #
    # @example
    #   todo.relative #=> "spec/spec_helper.rb"
    #
    # @return [String]
    # @api public
    def relative_path
      current_dir = Pathname.new(File.expand_path("./"))
      Pathname.new(path).relative_path_from(current_dir).to_s
    end

    protected

    # Helper for sorting todos
    #
    # @example
    #   todo.due_date_for_sorting #=> #<Date: 2016-02-06>
    #
    # @return [Date]
    # @api semipublic
    def due_date_for_sorting
      # Date.new is like the beginning of time
      due_date ? due_date.to_date : Date.new
    end

    private

    # What is the configuration for this code base's todo_lint setup?
    #
    # @return [Hash]
    # @api private
    attr_reader :config

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

    # A tag was referenced, so let's see when that's due
    # @return [DueDate]
    # @raise [KeyError] if the tag does not reference a due date in the config
    # @api private
    def lookup_tag_due_date
      config.fetch(:tags).fetch(match[:tag])
    rescue KeyError
      msg = "#{match[:tag]} tag not defined in config file"
      raise KeyError, msg
    end
  end
end
