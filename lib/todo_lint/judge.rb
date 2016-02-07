module TodoLint
  # Is this todo worth bothering the user about? Judge the todo, and charge it
  # with a crime if necessary
  class Judge
    # The problem, if any, with this todo
    # @example
    #   judge.charge #=> "The todo is overly dramatic"
    # @return [String] if the todo has something going on with it
    # @return [NilClass] if the todo is fine
    # @api public
    attr_reader :charge

    # Accept and judge a todo
    # @example
    #   Judge.new(todo)
    # @api public
    def initialize(todo)
      @todo = todo
      @charge = make_charge
    end

    private

    # Which todo is being judged?
    #
    # @return [Todo]
    # @api private
    attr_reader :todo

    # What is the problem with this todo?
    #
    # @return [String] if there's a problem
    # @return [NilClass] if no charge needed
    # @api private
    def make_charge
      if !todo.annotated?
        "Missing due date annotation"
      elsif todo.due_date.overdue? && todo.tag?
        "Overdue due date #{todo.due_date.to_date} via tag"
      elsif todo.due_date.overdue?
        "Overdue due date"
      end
    end
  end
end
