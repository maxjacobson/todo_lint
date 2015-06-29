# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "todo_lint/version"

Gem::Specification.new do |spec|
  spec.name          = "todo_lint"
  spec.version       = TodoLint::VERSION
  spec.authors       = ["Max Jacobson"]
  spec.email         = ["max@hardscrabble.net"]

  spec.summary       = "Linter to help you remember your todos"
  spec.description   = "todo_lint can be integrated into a continuous " \
                       "integration workflow to keep todo comments from " \
                       "becoming stagnant over time. Just annotate the " \
                       "comment with a date, and if that date has passed, " \
                       "your build will fail, and you'll be reminded to " \
                       "snooze the todo a little later, or finally address it."
  spec.homepage      = "https://github.com/maxjacobson/todo_lint"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "required_arg", "~> 1.0"
  spec.add_runtime_dependency "rainbow", "~> 2.0.0"
  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "yardstick"
  spec.add_development_dependency "pry"
end
