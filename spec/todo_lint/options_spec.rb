require "spec_helper"

module TodoLint #:nodoc:
  describe Cli do
    let(:fake_project_path) { File.expand_path("../../fake_project", __FILE__) }
    let(:lib_path) { File.expand_path("../../../lib", __FILE__) }
    let(:app_rb) { File.join(fake_project_path, "app.rb") }
    let(:app_spec_rb) { File.join(fake_project_path, "spec", "app_spec.rb") }
    let(:app_js) { File.join(fake_project_path, "app.js") }
    let(:app_coffee) { File.join(fake_project_path, "app.coffee") }
    let(:todo_lint_rb) { File.join(lib_path, "todo_lint.rb") }
    it "should not look at excluded files, and look at .rb by default" do
      cli_test = Cli.new(["todo_lint", "-e", "#{app_rb}"])
      options_hash = cli_test.instance_variable_get(:@options)
      path = cli_test.instance_variable_get(:@path)
      file_finder_test = FileFinder.new(path, options_hash)
      expect(options_hash.fetch(:excluded_files)).to include(app_rb)
      list_of_files = file_finder_test.list(*options_hash[:extensions])
      expect(list_of_files).to include(app_spec_rb)
      expect(list_of_files).to_not include(app_rb)
      expect(list_of_files).to_not include(app_coffee)
      expect(list_of_files).to_not include(app_js)
    end
    it "should not look at excluded folders" do
      cli_test = Cli.new(["todo_lint", "-e", "spec/fake_project/**"])
      options_hash = cli_test.instance_variable_get(:@options)
      path = cli_test.instance_variable_get(:@path)
      file_finder_test = FileFinder.new(path, options_hash)
      list_of_files = file_finder_test.list(*options_hash[:extensions])
      expect(list_of_files).to_not include(app_spec_rb)
      expect(list_of_files).to_not include(app_rb)
      expect(list_of_files).to_not include(app_coffee)
      expect(list_of_files).to_not include(app_js)
    end
    it "should allow for multiple parameters" do
      cli_test = Cli.new(["-e", "spec/**,lib/todo_lint/**"])
      options_hash = cli_test.instance_variable_get(:@options)
      path = cli_test.instance_variable_get(:@path)
      file_finder_test = FileFinder.new(path, options_hash)
      list_of_files = file_finder_test.list(*options_hash[:extensions])
      expect(list_of_files).to_not include(app_spec_rb)
      expect(list_of_files).to_not include(app_rb)
      expect(list_of_files).to_not include(app_coffee)
      expect(list_of_files).to include(todo_lint_rb)
    end
    it "should only look at specified extensions" do
      cli_test = Cli.new(["-x", ".js,.coffee"])
      options_hash = cli_test.instance_variable_get(:@options)
      path = cli_test.instance_variable_get(:@path)
      file_finder_test = FileFinder.new(path, options_hash)
      list_of_files = file_finder_test.list(*options_hash[:extensions])
      expect(list_of_files).to_not include(app_spec_rb)
      expect(list_of_files).to_not include(app_rb)
      expect(list_of_files).to include(app_coffee)
      expect(list_of_files).to include(app_js)
    end
    it "should not look at excluded extensions" do
    end
  end
end
