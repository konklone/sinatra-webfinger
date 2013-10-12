## A Webfinger plugin for Sinatra.

An easy Sinatra plugin for adding Webfinger support to your domain.

**Current State:** Under rapid development to prepare for public release. Not announced, or guaranteed to be working yet.

### What is Webfinger?

It's a way to attach information to your email address.

Take an email address, and ask its domain about it using HTTPS. For example, information about `eric@konklone.com` is available in JSON at:

```
https://konklone.com/.well-known/webfinger?resource=eric@konklone.com
```

See [webfinger.net](http://webfinger.net), [Mike Jones' description](http://www.packetizer.com/webfinger/), or Webfinger's official standard at [RFC 7033](http://tools.ietf.org/html/rfc7033) for more information.

### Using sinatra-webfinger

**sinatra-webfinger** is a small Sinatra plugin optimized for single users, where you own your domain name, and you want to attach information to your email address.

Install it:

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

This will add a GET endpoint at `/.well-known/webfinger?resource=acct:eric@konklone.com` that produces:

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

### Behavior of /.well-known/webfinger

The `Content-Type` of the response will be `application/jrd+json`, and [CORS](http://enable-cors.org/) will be enabled (`Access-Control-Allow-Origin` will be `*`).

A **400** will be returned if:

* There is no `resource` parameter provided in the query string.
* There's any sort of Exception while parsing the `resource` URI.

A **404** will be returned if:

* A URI scheme other than `acct` is submitted.
* A `resource` is submitted for an `acct` that isn't listed in the configuration.

A **500** will be returned if:

* `Sinatra::Webfinger.config` has not been set to anything.
* There is any unplanned Exception.


### Configuration

Configure `sinatra-webfinger` by setting `Sinatra::Webfinger.config` to an array of details. Each item in the array is a hash containing the following keys and values:

`acct`: Email address that the rest of the fields apply to. e.g. `yourname@example.com`.

`properties`: A hash where each key is the name of a property, and each value is its value. e.g. `{"name": "Your Name"}`

`links`: A hash where each key is the `rel` of the link, and each value is the `href` of the link. e.g. `{"website": "https://example.com"}`


#### Example YAML configuration

It may be easiest to serialize your Webfinger configuration in YAML, then load it into Ruby and assign it to `Sinatra::Webfinger.config`.

An example YAML file for [the above example](#using-sinatra-webfinger) would be:

```yaml
webfinger:
- acct: eric@konklone.com
  properties:
    name: Eric Mill
    twitter: konklone
  links:
    website: https://konklone.com
```

If you saved that to `config.yml`, you might configure your application using:

```ruby
config = YAML.load_file 'config.yml'

Sinatra::Webfinger.config = config['webfinger']
```

### Public Domain

This project is [dedicated to the public domain](LICENSE).