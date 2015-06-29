require "spec_helper"

module TodoLint
  describe DueDate do
    describe "::from_annotation and #to_date" do
      it "parses dates from annotations" do
        due_date = DueDate.from_annotation("(2015-06-28)")
        expect(due_date.to_date).to eq Date.new(2015, 06, 28)
      end

      it "complains on invalid input" do
        expect do
          DueDate.from_annotation("omg")
        end.to raise_error(ArgumentError, 'not a properly formatted annotation: "omg"')
      end
    end
  end
end
