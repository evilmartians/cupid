# Cupid gem — Create, organize and send emails through Exact Target

Send love, not war. This version of cupid can only work with ET SOAP API with s4.

Sponsored by Evil Martians <http://evilmartians.com>

## Usage

Get a new cupid object for every account you want to work with (usually
it's the only one):

``` ruby
  Cupid::MyAccount = Cupid.new :username, :password, :account
```

Now you can send requests to ExactTarget through this object.

Small example:

``` ruby
  Cupid::MyAccount.tap do |it|
    list = it.lists.last
    new_email = it.create_email :subject, :body
    it.create_delivery list, new_email
    it.delete_emails *it.emails
  end
```

There is much more underneath. See specs for some examples.

## Installation

Puts this line into `Gemfile` then run `$ bundle`:

``` ruby
gem 'cupid'
```

Or if you are old-school Rails 2 developer put this into `config/environment.rb` and run `$ rake gems:install`:

``` ruby
config.gem 'cupid'
```

Or manually install cupid gem: `$ gem install cupid`

## Contributors

* @gazay, @brainopia

## License

The MIT License

Copyright (c) 2011 Alexey Gaziev <gazay@evilmartians.com>

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

