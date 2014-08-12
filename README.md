# faraday_curl

This middleware logs your HTTP requests as CURL compatible commands so you can share the calls you're making with someone else or keep them for debugging purposes.

## Installation

Add this line to your application's Gemfile:

    gem 'faraday_curl'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install faraday_curl

## Usage

This gem provides a request middleware so you have to require and declare it at your Faraday middleware stack:

```ruby
require 'faraday_curl'
require 'logger'

domain = "http://example.com/"
logger = Logger.new(STDOUT)

Faraday.new(:url => domain) do |f|
  f.request :url_encoded  
  f.request :curl, logger, :warn
  f.adapter Faraday.default_adapter
end
```

The middleware takes a `logger` object and a `log level` parameter and it will call the log level declared with the CURL compatible command to print it. The request should be the **last** request middleware to make sure the body is already a string.

## Contributing

1. Fork it ( http://github.com/mauricio/faraday-curl/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
