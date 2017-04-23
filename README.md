# Ampize

Ampize replaces tags to AMP specific tags and removes prohibited tags and attributes.  
If img tag doesn't explictly specify a size Ampize download a source image and set a size to amp-img tag automatically.


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

If img element doesn't have width/height attributes then Ampize download an image to get a dimension.
Ofcourse if img element have a size Ampize keep it.

Currently Ampize doesn't support amp-audio, amp-video.
Your contribution is always welcome.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/dotneet/ampize.

