frogger-logger  [![Build Status](https://travis-ci.org/ciembor/frogger-logger.svg?branch=master)](https://travis-ci.org/ciembor/frogger-logger) [![Dependency Status](https://gemnasium.com/ciembor/frogger-logger.svg)](https://gemnasium.com/ciembor/frogger-logger) [![Code Climate](https://codeclimate.com/github/ciembor/frogger-logger.png)](https://codeclimate.com/github/ciembor/frogger-logger)
=======
|![Obey!](http://oi59.tinypic.com/33lcao2.jpg)|Add `gem 'frogger-logger'` line to the `:development` section of your Gemfile. After this run `bundle install`. Obey. :frog:|
|:---:|:---:|
## Rails logger for a browser's console.
This logger will allow you to log from your Ruby (Rails?) code directly to your browser.
## Usage
### :frog: Install
Add `gem 'frogger-logger'` line to the `:development` section of your Gemfile. Then run:
```bash
bundle install
```
### :frog: Configure
Here is example configuration with default values. If you use Rails, the best place to put this code is `config/environments/development.rb`.
```ruby
FroggerLogger.configure do |config|
  config.host = '0.0.0.0'
  config.port = 2999
  config.client_js_path = '/assets/frogger_logger/client.js'
  config.history_expiration_time = 600
  config.extend_with_dsl = true
  config.json_format = true
end
```
## :frog: Use
If you didn't disable the dsl (`config.extend_with_dsl = false`), you can log very easly
```ruby
frog 'this will be logged :)'
```
Also if you didn't disable translating to json (`config.json_format = false`), your objects will be automagically translated to this format. This allows you to browse ruby objects, arrays and hashes in your browser!
## Development
### Downloading source
```bash
git clone https://github.com/ciembor/frogger-logger.git
```
### Preparing gem
```bash
gem build frogger-logger.gemspec
```
```bash
gem install frogger-logger-x.x.x.gem --dev
```
### Running specs
To run all specs:
```bash
rake travis
```
or simply
```bash
rake
```
To run Ruby specs:
```bash
bundle exec rspec
```
To run JavaScript specs:
```bash
rake jasmine:ci
```
