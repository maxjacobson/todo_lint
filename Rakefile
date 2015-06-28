require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yardstick/rake/verify"

RSpec::Core::RakeTask.new(:function)
RuboCop::RakeTask.new(:form)
Yardstick::Rake::Verify.new(:clarity)

task :default => [:function, :form, :clarity]
