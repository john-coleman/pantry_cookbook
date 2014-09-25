require 'foodcritic'
require 'rubocop/rake_task'

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

desc 'Run tests, Foodcritic, RuboCop'
task default: [:foodcritic, :rubocop]

desc 'Run Foodcritic'
FoodCritic::Rake::LintTask.new do |t|
  t.options = { fail_tags: ['any'] }
end

desc 'Run RuboCop'
RuboCop::RakeTask.new(:rubocop) do |task|
  # only show the files with failures
  task.formatters = ['files']
  # don't abort rake on failure
  task.fail_on_error = true
end

