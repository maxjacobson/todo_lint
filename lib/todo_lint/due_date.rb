module TodoLint
  # When is this todo actually due? When ought we be reminded of this one?
  class DueDate
    ANNOTATION_PATTERN = /\((\d{4})-(\d{2})-(\d{2})/

    # Parse the date from the todo comment's due date annotation
    # @example
    #   DueDate.from_annotation("(2015-04-14)")
    # @return [DueDate] if the annotation is formatted properly
    # @raise [ArgumentError] if the annotation is not formatted properly
    # @api public
    def self.from_annotation(annotation)
      if (match = ANNOTATION_PATTERN.match(annotation))
        DueDate.new(Date.new(match[1].to_i, match[2].to_i, match[3].to_i))
      else
        msg = "not a properly formatted annotation: #{annotation.inspect}"
        raise ArgumentError, msg
      end
    end

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
  end
end
