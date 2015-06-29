$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "todo_lint"
require "timecop"
require "pry"

# Disable colorful output in specs
# This makes it easier to test and compare strings
Rainbow.enabled = false
