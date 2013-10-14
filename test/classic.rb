require 'sinatra/base'

require '../lib/sinatra/webfinger'

class Classic < Sinatra::Base
  register Sinatra::Webfinger

  webfinger "eric@konklone.com" => {
    name: "Eric Mill",
    website: "https://konklone.com"
  }

  get('/') {'Hello world!'}
end