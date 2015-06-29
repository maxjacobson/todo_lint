module TodoLint
  class DueDate
    ANNOTATION_PATTERN = /\((\d{4})-(\d{2})-(\d{2})/

    def self.from_annotation(annotation)
      if match = ANNOTATION_PATTERN.match(annotation)
        DueDate.new(Date.new(match[1].to_i, match[2].to_i, match[3].to_i))
      else
        msg = "not a properly formatted annotation: #{annotation.inspect}"
        raise ArgumentError, msg
      end
    end

    def initialize(date)
      @date = date
    end

    def to_date
      date
    end

    private

    attr_reader :date
  end
end
