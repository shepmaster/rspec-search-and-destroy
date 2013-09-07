require "bundler/gem_tasks"

require "cucumber"
require "cucumber/rake/task"
Cucumber::Rake::Task.new(:features)

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

desc "Run all tests"
task test: [:features, :spec]
