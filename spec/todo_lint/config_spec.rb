require "spec_helper"

module TodoLint #:nodoc:
  describe ConfigFile do
    let(:fake_project_path) { File.expand_path("../../fake_project", __FILE__) }
    let(:exclude_file_yaml) { File.join(fake_project_path, ".todo_lint_1.yml") }
    let(:extensions_yaml) { File.join(fake_project_path, ".todo_lint_2.yml") }
    let(:multiple_yaml) { File.join(fake_project_path, ".todo_lint_3.yml") }
    let(:app_rb) { File.join(fake_project_path, "app.rb") }
    let(:app_spec_rb) { File.join(fake_project_path, "spec", "app_spec.rb") }
    let(:app_js) { File.join(fake_project_path, "app.js") }
    let(:app_coffee) { File.join(fake_project_path, "app.coffee") }
    # Specifications: Exclude Files: app_spec.rb
    it "should not look at files excluded in the yaml file" do
      cli_test = Cli.new(["-c", "#{exclude_file_yaml}"])
      options_hash = cli_test.instance_variable_get(:@options)
      path = cli_test.instance_variable_get(:@path)
      file_finder_test = FileFinder.new(path, options_hash)
      expect(options_hash.fetch(:excluded_files)).to include(app_spec_rb)
      list_of_files = cli_test.load_files(file_finder_test)
      expect(list_of_files).to_not include(app_spec_rb)
      expect(list_of_files).to include(app_rb)
      expect(list_of_files).to_not include(app_coffee)
      expect(list_of_files).to_not include(app_js)
    end
    # Specifications: Extensions: .js, .coffee
    it "should not look at only extensions specified in the yaml file" do
      cli_test = Cli.new(["-c", "#{extensions_yaml}"])
      options_hash = cli_test.instance_variable_get(:@options)
      path = cli_test.instance_variable_get(:@path)
      file_finder_test = FileFinder.new(path, options_hash)
      list_of_files = cli_test.load_files(file_finder_test)
      expect(list_of_files).to_not include(app_spec_rb)
      expect(list_of_files).to_not include(app_rb)
      expect(list_of_files).to include(app_coffee)
      expect(list_of_files).to include(app_js)
    end
    # Specifications: Exclude Files: app.js Extensions: .rb, .js, .coffee
    it "should allow for multiple specifications" do
      cli_test = Cli.new(["-c", "#{multiple_yaml}"])
      options_hash = cli_test.instance_variable_get(:@options)
      path = cli_test.instance_variable_get(:@path)
      file_finder_test = FileFinder.new(path, options_hash)
      list_of_files = cli_test.load_files(file_finder_test)
      expect(list_of_files).to include(app_spec_rb)
      expect(list_of_files).to include(app_rb)
      expect(list_of_files).to include(app_coffee)
      expect(list_of_files).to_not include(app_js)
    end
  end
end
