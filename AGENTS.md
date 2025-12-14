# Agent Guidelines for crypto_wallet_tool

This document provides guidelines for AI agents (like Claude, Copilot, etc.) working on the crypto_wallet_tool project.

## Project Overview

crypto_wallet_tool is a Ruby gem that provides utilities for working with cryptocurrencies and blockchain technologies. It currently includes:

- **Converter**: Utilities for converting between different cryptocurrency formats
- **Client**: Ethereum JSON-RPC client for interacting with Ethereum nodes

## Development Environment Setup

### Prerequisites
- Ruby 3.2 or higher
- Bundler for dependency management
- Git for version control

### Initial Setup
```bash
# Install dependencies
bundle install

# Run tests
bundle exec rspec

# Run linter
bundle exec rubocop
```

## Code Style and Standards

### Ruby Conventions
- Follow Ruby community style guidelines
- Use RuboCop for automated style checking
- Configuration: `.rubocop.yml`
- Run `bundle exec rubocop` before committing
- Fix auto-correctable issues: `bundle exec rubocop -a`

### Naming Conventions
- Use snake_case for method names and variables
- Use PascalCase for class and module names
- Use SCREAMING_SNAKE_CASE for constants
- Prefix private methods with underscore when appropriate

### Documentation
- Use YARD-style documentation for public methods
- Include parameter types and return types
- Add usage examples for complex functionality
- Keep documentation concise but complete

Example:
```ruby
# Retrieves a transaction by its hash.
#
# @param transaction_hash [String] The transaction hash (0x-prefixed)
# @return [Hash, nil] The transaction data, or nil if not found
# @raise [RPCError] If the RPC call fails
def eth_get_transaction_by_hash(transaction_hash)
  # ...
end
```

## Testing Guidelines

### Test Structure
- All tests live in `spec/` directory
- Use RSpec as the testing framework
- Mirror the structure of `lib/` in `spec/`
- Test file naming: `*_spec.rb`

### Test Coverage Requirements
- Aim for high test coverage (>90%)
- Test both happy paths and error conditions
- Use WebMock for HTTP request mocking
- Include edge cases and boundary conditions

### Running Tests
```bash
# Run all tests
bundle exec rspec

# Run specific test file
bundle exec rspec spec/crypto_wallet_tool/client_spec.rb

# Run with coverage report
bundle exec rspec --format documentation
```

## Client Implementation Guidelines

### JSON-RPC Client
When working with the Ethereum JSON-RPC client:

1. **Error Handling**
   - Use custom exception classes (RPCError, TransactionNotFoundError)
   - Validate responses before returning results
   - Provide clear error messages

2. **Input Validation**
   - Validate transaction hashes (0x-prefixed, 64 hex characters)
   - Validate URLs and endpoints
   - Check parameter types and formats

3. **Network Operations**
   - Configure appropriate timeouts
   - Handle network failures gracefully
   - Consider retry logic for transient failures

4. **Thread Safety**
   - Consider concurrent request scenarios
   - Use thread-safe ID generation
   - Document any thread-safety limitations

## Git Workflow

### Branch Naming
- Feature branches: `feature/description`
- Bug fixes: `fix/description`
- Agent work: `claude/description` or `copilot/description`

### Commit Messages
- Use conventional commit format: `type: description`
- Types: feat, fix, docs, style, refactor, test, chore
- Keep first line under 72 characters
- Add detailed explanation in body if needed

Example:
```
feat: add retry logic to JSON-RPC client

Implements exponential backoff retry for transient network failures.
Configurable retry attempts and delays. Defaults to 3 retries with
1s, 2s, 4s delays.
```

### Pull Request Guidelines
- Reference related issues with "Closes #N" or "Resolves #N"
- Provide clear description of changes
- Include test coverage for new features
- Ensure CI passes before requesting review

## Common Tasks for Agents

### Adding New RPC Methods
1. Add method to `lib/crypto_wallet_tool/client.rb`
2. Add comprehensive tests in `spec/crypto_wallet_tool/client_spec.rb`
3. Document the method with YARD comments
4. Update README if it's a major feature
5. Ensure all tests pass

### Fixing Bugs
1. Write a failing test that reproduces the bug
2. Fix the implementation
3. Verify the test now passes
4. Check for similar issues in related code
5. Update documentation if behavior changes

### Improving Documentation
1. Check current documentation for accuracy
2. Add missing examples and use cases
3. Update README with new features
4. Consider adding runnable examples in `examples/`
5. Ensure code comments are up-to-date

### Adding New Public Methods
When adding new public methods or classes to the gem, you must also update the API documentation:

1. Add the method implementation with proper YARD documentation
2. Add comprehensive tests for the new method
3. **Update `docs/API.md`** with:
   - Method signature and description
   - Parameter documentation
   - Return value documentation
   - Usage examples in Japanese
   - Error handling examples if applicable
4. Keep API.md organized by module/class hierarchy
5. Ensure examples are practical and easy to understand

The API.md file serves as the primary reference for gem users to discover and understand available methods. Keeping it up-to-date is essential for good user experience.

## Testing Strategies

### Unit Testing
- Mock external dependencies (HTTP requests, file I/O)
- Test individual methods in isolation
- Use RSpec's `let`, `subject`, and `describe`/`context` blocks
- Keep tests focused and readable

### Integration Testing
- Test interactions between components
- Use real objects where possible (avoid over-mocking)
- Test error propagation and handling

### E2E Testing
- See `docs/TODO.md` for E2E testing implementation plans
- Use testnet for real network testing
- Consider local node (Ganache/Hardhat) for full control
- Tag E2E tests to run separately from unit tests

## Security Considerations

### Input Validation
- Always validate external input (URLs, transaction hashes, etc.)
- Prevent injection attacks
- Validate data types and formats

### API Keys and Secrets
- Never commit API keys or secrets
- Use environment variables for sensitive data
- Document required environment variables in README

### Network Security
- Validate URLs to prevent SSRF attacks
- Use HTTPS for production RPC endpoints
- Configure appropriate timeouts to prevent DoS

## Performance Guidelines

### Efficiency
- Reuse HTTP connections where possible
- Avoid unnecessary object allocations
- Cache results when appropriate
- Consider rate limiting for API calls

### Benchmarking
- Benchmark performance-critical code
- Document performance characteristics
- Monitor for regressions in CI

## Future Considerations

Refer to `docs/TODO.md` for:
- Planned features and improvements
- Known limitations and workarounds
- Enhancement proposals
- Technical debt to address

## Getting Help

### Resources
- [Ruby Style Guide](https://rubystyle.guide/)
- [RSpec Documentation](https://rspec.info/)
- [Ethereum JSON-RPC Specification](https://ethereum.github.io/execution-apis/api-documentation/)
- [YARD Documentation](https://yardoc.org/)

### Project Files
- `README.md` - User-facing documentation
- `docs/TODO.md` - Future improvements and tasks
- `.rubocop.yml` - Code style configuration
- `crypto_wallet_tool.gemspec` - Gem metadata and dependencies

## Notes for AI Agents

### Context Awareness
- Always read the issue/PR description carefully
- Check for related issues and PRs
- Review recent commits for context
- Read test files to understand expected behavior

### Making Changes
- Run tests before and after changes
- Follow existing code patterns and styles
- Update documentation alongside code changes
- Consider backward compatibility

### Communication
- Provide clear explanations of changes
- Document assumptions and decisions
- Ask for clarification when requirements are unclear
- Reference specific files and line numbers in discussions

## examples/rails_app Requirements

The `examples/rails_app` directory contains a sample Rails application demonstrating the crypto_wallet_tool gem's API functionality. **All changes to this directory must pass both lint and test validations before work is considered complete.**

**Important**: The `examples/rails_app` is designed to run with Docker Compose. All commands should be executed via `docker compose` to ensure consistent environment.

### Docker Compose Setup

The application uses Docker Compose for development and testing. The `docker-compose.yml` defines:
- **web**: Rails application container
- **db**: PostgreSQL 15 database container

### Linting Requirements
```bash
cd examples/rails_app
docker compose run --rm web bin/rubocop
```

Or with GitHub Actions format:
```bash
cd examples/rails_app
docker compose run --rm web bin/rubocop -f github
```

**Expected Result**: No offenses detected. All code must conform to the project's RuboCop style guidelines.

### Testing Requirements
```bash
cd examples/rails_app

# Start database service
docker compose up -d db

# Run tests in test environment
docker compose run --rm -e RAILS_ENV=test -e DATABASE_URL="postgresql://postgres:postgres@db:5432/rails_app_test" web bin/rails db:create db:prepare
docker compose run --rm -e RAILS_ENV=test -e DATABASE_URL="postgresql://postgres:postgres@db:5432/rails_app_test" web bin/rspec --format documentation
```

**Expected Result**: All specs passing. Tests cover:
- Converter API endpoints (6 endpoints)
- Ethereum API endpoints (4 endpoints)
- Debug API endpoints (2 endpoints)

### CI/CD Validation
The `rails-app-ci.yml` workflow automatically validates:
1. **security_scan**: Brakeman security checks
2. **lint**: RuboCop style checks
3. **routes_check**: Route configuration validation
4. **test**: RSpec test suite with PostgreSQL

**All jobs must pass** for pull requests affecting the `examples/rails_app/` directory.

### Required Dependencies
- Docker and Docker Compose (required for running the application)
- Ruby 3.2.9 (specified in `.ruby-version`, used in Docker container)
- PostgreSQL 15+ (provided by Docker Compose `db` service)
- All gems in `Gemfile` including:
  - `rspec-rails` for testing
  - `rubocop-rspec` for RSpec-specific linting
  - `rswag` gems for API documentation

### Running Commands via Docker Compose

All Rails commands should be executed through Docker Compose:
```bash
cd examples/rails_app

# Lint
docker compose run --rm web bin/rubocop

# Security scan
docker compose run --rm web bin/brakeman --no-pager

# Routes check
docker compose run --rm web bin/rails routes | grep health

# Database setup (test environment)
docker compose run --rm -e RAILS_ENV=test -e DATABASE_URL="postgresql://postgres:postgres@db:5432/rails_app_test" web bin/rails db:create db:prepare

# Run tests
docker compose run --rm -e RAILS_ENV=test -e DATABASE_URL="postgresql://postgres:postgres@db:5432/rails_app_test" web bin/rspec
```

---

Last updated: 2025-12-14
