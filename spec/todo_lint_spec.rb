require "spec_helper"

RSpec.describe TodoLint do
  it "has a version number" do
    expect(TodoLint::VERSION).to be_a String
  end
end
