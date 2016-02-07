require "spec_helper"

module TodoLint #:nodoc:
  describe Todo do
    let(:examples) { File.expand_path("../../fake_example_files", __FILE__) }
    let(:offensive_filename) { File.join(examples, "with_unannotated_todo.js") }
    let(:file) { File.open(offensive_filename) }
    let(:path) { file.path }

    def todo_with_line(line, line_number: rand(1000))
      Todo.new(line, :path => path, :line_number => line_number)
    end

    describe "::within" do
      it "returns a list of offenses" do
        todos = Todo.within(file)
        expect(todos.length).to eq 1
        todo = todos.first
        expect(todo).to be_a Todo
        expect(todo.line_number).to eq 2
        expect(todo.character_number).to eq 6
      end
    end

    describe "::new" do
      let(:line) { "# TODO: get a good night's sleep" }
      context "with a todo comment and line number" do
        it "makes a todo" do
          todo = Todo.new(line, :line_number => 47, :path => path)
          expect(todo.line).to eq line
          expect(todo.line_number).to eq 47
        end
      end

      context "with a todo comment and without a line number" do
        # I'm testing this because I want to support Ruby 2.0.0, so I can't
        # use native required keywords arguments
        it "raises ArgumentError" do
          expect { Todo.new(line, :path => path) }.to raise_error(ArgumentError)
        end
      end

      context "with a non-todo comment and with a line number" do
        it "raises ArgumentError" do
          expect do
            Todo.new("Hello World", :line_number => 4, :path => path)
          end.to raise_error(ArgumentError)
        end
      end
    end

    describe "#character" do
      it "should find where the todo comment begins, 1 indexed" do
        todo = todo_with_line("  # TODO: cook a cobbler")
        expect(todo.character_number).to eq 5
      end
    end

    describe "#annotated?, #flag, #due_date" do
      context "when the line is annotated with a due date" do
        it "should return true" do
          todo = todo_with_line("# TODO(2015-08-29): solve a crime")
          expect(todo).to be_annotated
          expect(todo.flag).to eq "TODO"
          expect(todo.due_date).to be_a DueDate
          expect(todo.due_date.to_date).to eq Date.new(2015, 8, 29)
        end
      end

      context "when the line is not annotated with a date" do
        it "should return false" do
          todo = todo_with_line("# TODO: solve a crime")
          expect(todo).to_not be_annotated
          expect(todo.due_date).to be_nil
          expect(todo.flag).to eq "TODO"
        end
      end
    end

    xdescribe "#relative_path"

    describe "sorting" do
      context "when all of the todos have due dates" do
        it "sorts them with newer todos first" do
          todos = [
            todo_with_line("# TODO(1969-04-04): commit a crime"),
            todo_with_line("# TODO(1955-08-02): plan a crime")
          ]

          expect(todos.sort.map(&:task)).to eq [
            "plan a crime",
            "commit a crime"
          ]
        end
      end

      context "when some of the todos don't have due dates" do
        it "sorts the unannotated ones to the front" do
          todos = [
            todo_with_line("# TODO(1969-04-04): commit a crime"),
            todo_with_line("# TODO: buy some spray paint"),
            todo_with_line("# TODO(1955-08-02): plan a crime")
          ]

          expect(todos.sort.map(&:task)).to eq [
            "buy some spray paint",
            "plan a crime",
            "commit a crime"
          ]
        end
      end
    end
  end
end
