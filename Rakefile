begin
  require 'rspec/core/rake_task'
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
