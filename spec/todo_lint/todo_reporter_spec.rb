require "spec_helper"

module TodoLint #:nodoc:
  describe TodoReporter do
    # TODO: figure out the color coding part of it
    describe "#to_s" do
      it "reports on a todo" do
        todo = Todo.new("  # TODO: glimpse infinity", :line_number => 45)
        reporter = TodoReporter.new(todo,
                                    :path => "/Users/max/src/layabout/Gemfile")

        expected_report = "/Users/max/src/layabout/Gemfile:45:5 " \
                          "Missing due date annotation\n" \
                          "  # TODO: glimpse infinity\n" \
                          "    ^^^^"
        expect(reporter.report).to eq expected_report
      end
    end
  end
end
