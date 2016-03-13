require "spec_helper"

module TodoLint
  describe DueDate do
    before do
      Timecop.freeze(Time.local(1988, 8, 29))
    end

    after do
      Timecop.return
    end

    describe "::from_annotation and #to_date" do
      it "parses dates from annotations" do
        due_date = DueDate.from_annotation("(2015-06-28)")
        expect(due_date.to_date).to eq Date.new(2015, 06, 28)
      end

      it "complains on invalid input" do
        expect do
          DueDate.from_annotation("omg")
        end.to raise_error(
          ArgumentError, 'not a properly formatted date: "omg"')
      end
    end

    describe "#overdue?" do
      it "returns true when the due date is older than today" do
        due_date = DueDate.from_annotation("(1985-05-24)")
        expect(due_date).to be_overdue
      end

      it "returns false when the due date is today" do
        due_date = DueDate.from_annotation("(1988-08-29)")
        expect(due_date).to_not be_overdue
      end

      it "returns false when the due date is in the future" do
        due_date = DueDate.from_annotation("(1994-05-11)")
        expect(due_date).to_not be_overdue
      end
    end
  end
end
