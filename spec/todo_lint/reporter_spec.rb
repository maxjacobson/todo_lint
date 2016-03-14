require "spec_helper"

module TodoLint
  RSpec.describe Reporter do
    let(:path) { "/Users/max/src/layabout/Gemfile" }

    describe "#to_s" do
      it "reports on a todo with missing due date annotation" do
        todo = Todo.new(
          "  # TODO: glimpse infinity",
          :line_number => 45,
          :path => path,
          :config => {}
        )
        judge = instance_spy(Judge,
                             :charge => "Missing due date annotation")

        reporter = Reporter.new(todo, :judge => judge)

        expected_report = "/Users/max/src/layabout/Gemfile:45:5 " \
                          "Missing due date annotation\n" \
                          "# TODO: glimpse infinity\n" \
                          "  ^^^^"
        expect(reporter.report).to eq expected_report
      end

      it "does not report on a todo with a silent judge" do
        todo = Todo.new("  # TODO: follow your heart (1994-05-11)",
                        :line_number => 45,
                        :path => path,
                        :config => {})

        judge = instance_spy(Judge, :charge => nil)

        reporter = Reporter.new(todo, :judge => judge)
        expect(reporter.report).to be_nil
      end
    end
  end
end
