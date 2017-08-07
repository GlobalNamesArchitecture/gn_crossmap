# frozen_string_literal: true

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rubocop/rake_task"

RSpec::Core::RakeTask.new(:rspec) do |rspec|
  rspec.pattern = "spec/**/*_spec.rb"
end

RuboCop::RakeTask.new

task default: %i[rubocop rspec]
