require 'sinatra/base'

require '../lib/sinatra/webfinger'

class Classic < Sinatra::Base
  register Sinatra::Webfinger

  webfinger "eric@example.com" => {
    name: "Eric Example",
    twitter: "@ericatexampledotcom"
  }

  get('/') {'Hello world!'}
end