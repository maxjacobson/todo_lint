require "spec_helper"

module TodoLint #:nodoc:
  describe FileFinder do
    let(:fake_project_path) { File.expand_path("../../fake_project", __FILE__) }
    let(:app_js) { File.join(fake_project_path, "app.js") }
    let(:app_rb) { File.join(fake_project_path, "app.rb") }
    let(:app_spec_rb) { File.join(fake_project_path, "spec", "app_spec.rb") }
    let(:app_coffee) { File.join(fake_project_path, "app.coffee") }
    let(:finder) { FileFinder.new(fake_project_path, {}) }

    before do
      expect(File).to be_directory fake_project_path
      expect(File).to be_exist app_js
      expect(File).to be_exist app_rb
      expect(File).to be_exist app_spec_rb
      expect(File).to be_exist app_coffee
    end

    describe "#list" do
      it "finds an interesting list of files" do
        files = finder.list(".rb", ".coffee")

        expect(files.length).to eq 3

        expect(files).to include(app_rb)
        expect(files).to include(app_spec_rb)
        expect(files).to include(app_coffee)

        expect(files).to_not include(app_js)
      end
    end
  end
end
