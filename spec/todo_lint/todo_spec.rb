require "spec_helper"

module TodoLint #:nodoc:
  describe Todo do
    let(:examples) { File.expand_path("../../fake_example_files", __FILE__) }
    let(:offensive_filename) { File.join(examples, "with_unannotated_todo.js") }
    let(:file) { File.open(offensive_filename) }

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
  end
end
