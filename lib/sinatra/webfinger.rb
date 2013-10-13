require 'sinatra/base'
require 'multi_json'

# To use:
#
#   require 'sinatra/webfinger'
#
# In classic style:
#
#   webfinger(config)
#
# In modular style:
#
#

module Sinatra

  module Webfinger
    def webfinger(config)
      get '/.well-known/webfinger' do
        halt 500 unless config
        halt 400 unless (resource = params[:resource]).present?
        halt 400 unless (uri = URI.parse(resource) rescue nil)
        halt 404 unless uri.scheme == "acct" # acct only

        no_scheme = resource.sub /^acct:/, ''
        account = config['accounts'].find {|acct| acct['acct'] == no_scheme}
        halt 404 unless account

        response = {
          subject: resource,
          properties: account['properties'],
          links: [] # fill in next
        }
        account['links'].each do |rel, href|
          response[:links] << {rel: rel, href: href}
        end

        headers['Content-Type'] = 'application/jrd+json'
        headers['Access-Control-Allow-Origin'] = "*"

        MultiJson.encode response
      end
    end
  end

  register Webfinger
end