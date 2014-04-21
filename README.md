frogger-logger [![Build Status](https://travis-ci.org/ciembor/frogger-logger.svg?branch=master)](https://travis-ci.org/ciembor/frogger-logger) early development!
=======
|![Obey!](http://oi59.tinypic.com/33lcao2.jpg)|Add `gem 'frogger-logger'` line to the `:development` section of your Gemfile. After this run `bundle install`. You will love it :).|
|:---:|:---:|
## Rails logger for a browser's console.
This logger will allow you to log from your Ruby (Rails?) code directly to your browser.
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
