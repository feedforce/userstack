# Userstack

[![Travis Status](https://img.shields.io/travis/feedforce/userstack.svg?style=flat-square)][travisci]
[![License](https://img.shields.io/github/license/feedforce/userstack.svg?style=flat-square)][license]

[travisci]: https://travis-ci.org/feedforce/userstack
[license]: https://github.com/feedforce/userstack/blob/master/LICENSE.txt

This gem provides an access to [Userstack](https://userstack.com://userstack.com).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'userstack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install userstack

## Usage

1. Instantiate an instance of {Userstack::Client} with a valid Access key.

    ```ruby
    client = Userstack::Client.new(ACCESS_KEY)
    ```

2. Parse an useragent.

    ```ruby
    result = client.parse('an useragent')
    ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/userstack.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
