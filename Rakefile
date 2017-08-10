# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:rspec) do |rspec|
  rspec.pattern = "spec/**/*_spec.rb"
end

RuboCop::RakeTask.new

task default: %i[rubocop rspec]

desc "open an irb session preloaded with this gem"
task :console do
  sh "irb -r pp -r ./lib/gn_crossmap.rb"
end
