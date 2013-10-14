Gem::Specification.new do |s|
  s.name        = 'sinatra-webfinger'
  s.version     = '0.2.3'
  s.summary     = "A Sinatra plugin to add basic Webfinger support for one or more email addresses."
  s.description = "A Sinatra plugin to add basic Webfinger support for one or more email addresses."
  s.author      = "Eric Mill"
  s.email       = 'eric@konklone.com'
  s.files       = [
    "lib/sinatra/webfinger.rb",
    "data/urns.yml",
    "LICENSE",
    "README.md"
  ]
  s.homepage    = 'https://github.com/konklone/sinatra-webfinger'
  s.license     = "MIT"
  s.required_ruby_version = '>= 1.9.3'

  s.add_runtime_dependency "sinatra",">=1.3"
  s.add_runtime_dependency "multi_json", ">=1.0"
end