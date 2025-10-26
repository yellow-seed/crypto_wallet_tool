# Agent Guidelines for crypto_wallet_tool

This document provides guidelines for AI coding agents working on this repository.

## Code Quality Standards

### Linting and Style

**CRITICAL**: All code changes MUST pass RuboCop linting before being committed.

```bash
# Always run RuboCop before committing
bundle exec rubocop

# Auto-fix correctable offenses
bundle exec rubocop --auto-correct-all
```

#### Common RuboCop Rules

1. **String Literals**: Use single quotes unless string interpolation is needed
2. **Frozen String Literal**: All Ruby files must start with `# frozen_string_literal: true`
3. **Line Length**: Maximum 120 characters (specs excluded)
4. **Environment Variables**: Use `ENV.fetch('KEY', nil)` instead of `ENV['KEY']`
5. **RSpec Example Length**: Keep examples under 10 lines (use `around`, `let`, or helper methods)

### Testing

All code changes must include appropriate tests.

```bash
# Run all tests
bundle exec rspec

# Run with documentation format
bundle exec rspec --format documentation

# Run specific file
bundle exec rspec spec/path/to/spec.rb
```

#### Test Guidelines

1. Always reset global state in test cleanup (use `after` or `around` blocks)
2. Clean up environment variable modifications in tests
3. Maximum 5 expectations per example (RSpec/MultipleExpectations)
4. Maximum 3 nested groups (RSpec/NestedGroups)

### Git Workflow

#### Before Committing

1. Run linter: `bundle exec rubocop`
2. Run tests: `bundle exec rspec`
3. Review changes: `git diff`
4. Stage changes: `git add <files>`
5. Commit with descriptive message
6. Push to remote

#### Commit Message Format

```
<type>: <subject>

<optional body>

<optional footer>
```

**Types**: feat, fix, docs, style, refactor, test, chore

**Examples**:
- `feat: add transaction analysis functionality`
- `fix: correct environment variable handling in configuration`
- `refactor: simplify client initialization logic`
- `test: add coverage for edge cases in analyzer`

## Project Structure

```
crypto_wallet_tool/
├── lib/
│   ├── crypto_wallet_tool/        # Main gem functionality
│   │   ├── converter.rb
│   │   └── version.rb
│   ├── transaction_debugger/      # Transaction debugger module
│   │   ├── analyzer.rb
│   │   ├── client.rb
│   │   └── version.rb
│   └── transaction_debugger.rb
├── spec/
│   ├── crypto_wallet_tool/        # Tests for main gem
│   └── transaction_debugger_spec.rb
├── Gemfile
├── crypto_wallet_tool.gemspec
└── README.md
```

## Development Setup

### Initial Setup

```bash
# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run linter
bundle exec rubocop
```

### Adding New Features

1. **Plan**: Break down the feature into small, testable units
2. **Test First**: Write tests that describe expected behavior
3. **Implement**: Write minimal code to pass tests
4. **Refactor**: Clean up code while keeping tests green
5. **Document**: Add or update documentation
6. **Lint**: Ensure code passes RuboCop

### Adding Dependencies

1. Add to `crypto_wallet_tool.gemspec`:
   - Runtime dependencies: `spec.add_dependency`
   - Development dependencies: Add to Gemfile under `:development, :test` group
2. Run `bundle install`
3. Commit both gemspec and Gemfile.lock

## Common Patterns

### Configuration

```ruby
# Define configuration class
class Configuration
  attr_accessor :setting_name

  def initialize
    @setting_name = ENV.fetch('SETTING_NAME', 'default_value')
  end
end

# Module-level configuration
module MyModule
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end
end
```

### Client Pattern

```ruby
class Client
  attr_reader :url, :timeout

  def initialize(url: nil, timeout: nil)
    @url = url || MyModule.configuration.url
    @timeout = timeout || MyModule.configuration.timeout
  end

  # Client methods...
end
```

### Test Cleanup

```ruby
RSpec.describe MyModule do
  # Reset global state after each test
  after do
    described_class.instance_variable_set(:@configuration, nil)
  end

  # Clean up ENV modifications
  around do |example|
    original = ENV.fetch('MY_VAR', nil)
    example.run
    original ? ENV['MY_VAR'] = original : ENV.delete('MY_VAR')
  end
end
```

## Troubleshooting

### CI Failures

#### RuboCop Failures

```bash
# Check what's failing
bundle exec rubocop

# Auto-fix when possible
bundle exec rubocop --auto-correct-all

# Check specific file
bundle exec rubocop path/to/file.rb
```

#### Test Failures

```bash
# Run with backtrace for debugging
bundle exec rspec --backtrace

# Run only failed examples
bundle exec rspec --only-failures

# Run with seed for reproducibility
bundle exec rspec --seed 12345
```

## Style Preferences

### Ruby Style

- Prefer `attr_reader`/`attr_accessor` over manual getter/setter methods
- Use keyword arguments for methods with multiple parameters
- Prefer `fail` for exceptions in public APIs, `raise` in private methods
- Use descriptive variable names (avoid single-letter except for block parameters)

### RSpec Style

- Use `describe` for classes/modules, `context` for conditional behavior
- Use `it` with descriptive strings that complete "it..."
- Prefer `expect(...).to` over `expect(...).not_to` when possible
- Use `let` for reusable test data, `let!` when you need immediate evaluation

## Resources

- [RuboCop Documentation](https://docs.rubocop.org/)
- [RSpec Best Practices](https://rspec.info/documentation/)
- [Ruby Style Guide](https://rubystyle.guide/)
- [Semantic Versioning](https://semver.org/)

## Questions or Issues?

For project-specific questions, check:
1. This AGENTS.md file
2. README.md for user-facing documentation
3. Existing code patterns in the repository
4. RuboCop configuration in .rubocop.yml
