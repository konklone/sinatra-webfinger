### A Webfinger plugin for Sinatra.

An easy Sinatra plugin for adding Webfinger support to your domain.

Optimized for single users, where you own your domain and you want to attach information to your email address.

**Current State:** Under rapid development to prepare for public release. Not announced, or guaranteed to be working yet.

### Use

```bash
gem install sinatra-webfinger
```

Require it in your app:

```ruby
require 'sinatra/webfinger'
```

Configure it:

```ruby
Sinatra::Webfinger.config = [{
  'acct': 'eric@konklone.com',
  'properties': {
    'name': 'Eric Mill',
    'twitter': 'konklone'
  },
  'links': {
    'website': 'https://konklone.com'
  }
}]
```

You might consider storing this configuration in a YAML file ([example](#example-yaml-configuration)). Either way, only string values for keys are supported (no symbols).

This will produce a URL at `/.well-known/webfinger?resource=acct:eric@konklone.com` that produces:

```json
{
  "subject": "acct:eric@konklone.com",
  "properties": {
    "name": "Eric Mill",
    "twitter": "konklone"
  },
  "links": [
    {
      "rel": "website",
      "href": "https://konklone.com"
    }
  ]
}
```

The `Content-Type` of the response will be `application/jrd+json`, and [CORS](http://enable-cors.org/) will be enabled (`Access-Control-Allow-Origin` will be `*`).


### Configuration



#### Example YAML configuration



### Public Domain

This project is [dedicated to the public domain](LICENSE).