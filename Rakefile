require 'jasmine'

load 'jasmine/tasks/jasmine.rake'

task :travis do
  fail = false
  ['rspec spec', 'rake jasmine:ci'].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
    fail = true unless $?.exitstatus == 0
  end
  raise "Specs failed!" if fail
end

task default: :travis
