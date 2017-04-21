# Ampize

ampize replaces tags to AMP specific tags and removes prohibited tags and attributes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ampize'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ampize

## Usage

```ruby
ampize = Ampize::Ampize.new()
result = ampize.transform('<img src="./spec/data/rect.jpg" />')
puts result
>> <amp-img src="./spec/data/rect.jpg" width="100" height="100" layout="responsive"></amp-img>
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dotneet/ampize.

