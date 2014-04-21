require 'jasmine'

load 'jasmine/tasks/jasmine.rake'

task :travis do
  ['rspec spec', 'rake jasmine:ci'].each do |cmd|
    puts "Starting to run #{cmd}..."
    system("export DISPLAY=:99.0 && bundle exec #{cmd}")
  end
end

task default: :travis
