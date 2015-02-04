Gem::Specification.new do |s|
  s.name        = 'frogger-logger'
  s.version     = '0.0.1'
  s.date        = '2014-04-10'
  s.summary     = "Front-end logger for Ruby applications."
  s.description = "This logger will you to log from server-side applications (like Ruby on Rails or Sinatra) to the browser's JavaScript console."
  s.authors     = ["Maciej Ciemborowicz", "Marcin Kostrzewa"]

  s.add_runtime_dependency "em-websocket"
  s.add_runtime_dependency "nokogiri"

  s.add_development_dependency "em-websocket-client"
  s.add_development_dependency "jasmine", [">= 2.0.0"]
  s.add_development_dependency "rspec", [">= 2.14.1"]
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-rspec"
  s.files       = Dir['lib/**/*']
  s.homepage    = 'https://github.com/ciembor/frogger-logger/'
  s.license     = 'MIT'
end
