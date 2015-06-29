require "spec_helper"

module TodoLint #:nodoc:
  describe Judge do
    it "cares if the todo is missing its due date annotation" do
      todo = instance_spy(Todo, :annotated? => false)
      judge = Judge.new(todo)
      expect(judge.charge).to eq "Missing due date annotation"
    end

    it "cares if the due date annotation is in the past" do
      due_date = instance_spy(DueDate, :overdue? => true)
      todo = instance_spy(Todo, :annotated? => true, :due_date => due_date)
      judge = Judge.new(todo)
      expect(judge.charge).to eq "Overdue due date"
    end

    it "is only happy when the due date annotation is in the future" do
      due_date = instance_spy(DueDate, :overdue? => false)
      todo = instance_spy(Todo, :annotated? => true, :due_date => due_date)
      judge = Judge.new(todo)
      expect(judge.charge).to be_nil
    end
  end
end
