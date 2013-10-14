## A Webfinger plugin for Sinatra.

An easy Sinatra plugin for adding Webfinger support to your domain.

### What is Webfinger?

It's a way to attach information to your email address.

Take an email address, and ask its domain about it using HTTPS. For example, information about `eric@konklone.com` is available in JSON at:

```
https://konklone.com/.well-known/webfinger?resource=acct:eric@konklone.com
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

Configure it for your email address:

```ruby
webfinger "eric@konklone.com" => {
  name: "Eric Mill",
  website: "https://konklone.com"
}
```

This will add a GET endpoint at `/.well-known/webfinger?resource=acct:eric@konklone.com` that produces:

```json
{
  "subject": "eric@konklone.com",
  "properties": {
    "http://schema.org/name": "Eric Mill"
  },
  "links": [
    {
      "rel": "http://webfinger.net/rel/profile-page",
      "href": "https://konklone.com"
    }
  ]
}
```

If you're using the modular style of Sinatra app, by subclassing Sinatra::Base, make sure to register the extension inside your class:

```ruby
class MyApp < Sinatra::Base
  register Sinatra::Webfinger

  # ...rest of your app ...
end

You might consider storing your Webfinger configuration in a YAML file ([example](#example-yaml-configuration)).

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

Configure `sinatra-webfinger` by passing the `webfinger` method a hash where each key is an email address you want to attach details for. The value for each email address is another hash containing name/value pairs of data.

For each field, if its value is a URI beginning with `http` or `https`, it will be added to the Webfinger `links` array, where the field will be the `rel` and the value will be the `href`.

Otherwise, the field will be added to the Webfinger `properties` object, by that key and value.

That example again:

```ruby
webfinger "eric@konklone.com" => {
  name: "Eric Mill",
  website: "https://konklone.com"
}
``

So the above example will become:

```json
{
  "subject": "eric@konklone.com",
  "properties": {
    "http://schema.org/name": "Eric Mill"
  },
  "links": [
    {
      "rel": "http://webfinger.net/rel/profile-page",
      "href": "https://konklone.com"
    }
  ]
}
```

In Webfinger, fields are URIs, but you can use common short strings and `sinatra-webfinger` will convert those to the current best practice URIs for you.

These URIs are defined in [urns.yml](./data/urns.yml).

#### Configuration in YAML

It may be easiest to serialize your Webfinger configuration in YAML, then load it into Ruby and pass it to the `webfinger` method.

An example YAML file for the above example would be:

```yaml
eric@konklone.com:
  name: Eric Mill
  website: https://konklone.com
```

If you saved that to `webfinger.yml`, you might configure your application using:

```ruby
webfinger YAML.load_file('webfinger.yml')
```

### MIT License

This project is published [under the MIT License](LICENSE).