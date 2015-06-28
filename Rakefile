require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"
require "yardstick/rake/verify"

RSpec::Core::RakeTask.new(:spec)
RuboCop::RakeTask.new(:style)
Yardstick::Rake::Verify.new(:clarity)

task :default => [:spec, :style, :clarity]
