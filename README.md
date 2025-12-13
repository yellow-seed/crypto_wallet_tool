# CryptoWalletTool

[![Gem Version](https://badge.fury.io/rb/crypto_wallet_tool.svg)](https://badge.fury.io/rb/crypto_wallet_tool)
[![Build Status](https://github.com/your-username/crypto_wallet_tool/workflows/CI/badge.svg)](https://github.com/your-username/crypto_wallet_tool/actions)
[![codecov](https://codecov.io/gh/yellow-seed/crypto_wallet_tool/branch/main/graph/badge.svg)](https://codecov.io/gh/yellow-seed/crypto_wallet_tool)

A simple Ruby gem for input transformation and conversion. This gem provides various utility methods for text processing and data conversion.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'crypto_wallet_tool'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install crypto_wallet_tool
```

## Usage

### Basic Text Transformations

```ruby
require 'crypto_wallet_tool'

# Convert to uppercase
CryptoWalletTool::Converter.to_uppercase("hello world")
# => "HELLO WORLD"

# Convert to lowercase
CryptoWalletTool::Converter.to_lowercase("HELLO WORLD")
# => "hello world"

# Reverse text
CryptoWalletTool::Converter.reverse("hello")
# => "olleh"

# Convert to title case
CryptoWalletTool::Converter.to_title_case("hello world")
# => "Hello World"
```

### Case Conversions

```ruby
# Convert to snake_case
CryptoWalletTool::Converter.to_snake_case("helloWorld")
# => "hello_world"

# Convert to camelCase
CryptoWalletTool::Converter.to_camel_case("hello_world")
# => "helloWorld"
```

### String Manipulation

```ruby
# Remove all whitespace
CryptoWalletTool::Converter.remove_whitespace("hello world")
# => "helloworld"

# Convert to character array
CryptoWalletTool::Converter.to_char_array("hello")
# => ["h", "e", "l", "l", "o"]

# Convert array back to string
CryptoWalletTool::Converter.array_to_string(["h", "e", "l", "l", "o"])
# => "hello"
```

### Multiple Transformations

```ruby
# Apply multiple transformations in sequence
CryptoWalletTool::Converter.transform("hello world", [:to_uppercase, :reverse])
# => "DLROW OLLEH"

# Chain snake_case and remove_whitespace
CryptoWalletTool::Converter.transform("HelloWorld", [:to_snake_case, :remove_whitespace])
# => "helloworld"
```

## Available Methods

- `to_uppercase(input)` - Convert text to uppercase
- `to_lowercase(input)` - Convert text to lowercase
- `reverse(input)` - Reverse the input text
- `to_title_case(input)` - Convert to title case (capitalize each word)
- `to_snake_case(input)` - Convert to snake_case
- `to_camel_case(input)` - Convert to camelCase
- `remove_whitespace(input)` - Remove all whitespace
- `to_char_array(input)` - Convert string to array of characters
- `array_to_string(input)` - Convert array back to string
- `transform(input, transformations)` - Apply multiple transformations

## Development

### Using Docker (Recommended)

This project is configured to run in Docker containers, eliminating the need for local Ruby installation.

#### Setup

```bash
# Clone the repository
git clone https://github.com/your-username/crypto_wallet_tool.git
cd crypto_wallet_tool

# Build the Docker environment
docker-compose build
```

#### Docker Commands

```bash
# Build the image
docker-compose build

# Run tests
docker-compose run --rm test

# Open Ruby console
docker-compose run --rm console

# Open shell
docker-compose run --rm app /bin/bash

# Build gem
docker-compose run --rm build
```

### Local Development (Alternative)

If you prefer to run locally without Docker:

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Open console
bundle exec irb

# Build gem
bundle exec rake build
```

### Releasing

To release a new version:

1. Update the version number in `version.rb`
2. Run `docker-compose run --rm build` to build the gem
3. Run `bundle exec rake release` to create a git tag and push to [rubygems.org](https://rubygems.org)

## Testing

### Using Docker

```bash
# Run all tests
docker-compose run --rm test
```

### Local Testing

```bash
# Run all tests
bundle exec rspec

# Run with coverage
bundle exec rspec --format documentation
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/your-username/crypto_wallet_tool.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
