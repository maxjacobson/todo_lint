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
      if todo.annotated?
        @charge = "Overdue due date" if todo.due_date.overdue?
      else
        @charge = "Missing due date annotation"
      end
    end
  end
end
