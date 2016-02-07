require "date"

module TodoLint
  # When is this todo actually due? When ought we be reminded of this one?
  class DueDate
    DATE_PATTERN = /(\d{4})-(\d{2})-(\d{2})/
    ANNOTATION_PATTERN = /\(#{DATE_PATTERN}\)/

    # Parse the date from the todo_lint configuration file
    # @example
    #   DueDate.from_config_file("2015-04-14")
    # @return [DueDate] if the annotation is formatted properly
    # @raise [ArgumentError] if the annotation is not formatted properly
    # @api public
    def self.from_config_file(date)
      from_pattern(date, DATE_PATTERN)
    end

    # Parse the date from the todo comment's due date annotation
    # @example
    #   DueDate.from_annotation("(2015-04-14)")
    # @return [DueDate] if the annotation is formatted properly
    # @raise [ArgumentError] if the annotation is not formatted properly
    # @api public
    def self.from_annotation(date)
      from_pattern(date, ANNOTATION_PATTERN)
    end

    # Helper method for extracting dates from patterns
    # @return [DueDate] if pattern matches
    # @raise [ArgumentError] if pattern does not match
    # @api private
    def self.from_pattern(date, pattern)
      if (match = pattern.match(date))
        DueDate.new(Date.new(match[1].to_i, match[2].to_i, match[3].to_i))
      else
        msg = "not a properly formatted date: #{date.inspect}"
        raise ArgumentError, msg
      end
    end
    private_class_method :from_pattern

    # The actual date object when something is due
    # @example
    #   DueDate.new(Date.today).to_date == Date.today #=> true
    # @return [Date]
    # @api public
    attr_reader :to_date

    # Take a simple date object and imbue it with meaning
    # @example
    #   DueDate.new(Date.today)
    # @api public
    def initialize(date)
      @to_date = date
    end

    # Is this due date in the past?
    # @example
    #   due_date.overdue? #=> true
    # @return [Boolean]
    # @api public
    def overdue?
      Date.today > to_date
    end
  end
end
