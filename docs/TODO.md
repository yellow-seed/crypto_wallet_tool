# Future Improvements for crypto_wallet_tool

This document tracks recommended improvements and enhancements that should be implemented in future iterations.

## Documentation

### README Enhancements
- [ ] Add comprehensive `Client` usage examples section
  - Basic connection to Ethereum nodes (Infura, Alchemy, local)
  - Transaction retrieval examples
  - Contract interaction examples
  - Error handling patterns
- [ ] Add code examples for common use cases
- [ ] Document environment variable configuration
- [ ] Add troubleshooting section

### Examples Directory
- [ ] Create `examples/` directory with runnable sample code
  - `examples/basic_usage.rb` - Basic client operations
  - `examples/transaction_lookup.rb` - Transaction queries
  - `examples/contract_calls.rb` - Smart contract interactions
  - `examples/error_handling.rb` - Error handling patterns
- [ ] Add instructions for running examples
- [ ] Include real-world use case examples with testnet data

## Testing

### E2E Testing
- [ ] Implement E2E tests using Ethereum testnet (Sepolia recommended)
  - Configure RSpec to filter E2E tests with tags
  - Set up environment variables for testnet RPC URLs
  - Create test suite with known testnet transactions
  - Test all client methods against real network
- [ ] Alternative: Set up local Ganache/Hardhat node for E2E tests
  - Add Docker Compose configuration for local test node
  - Implement test helpers for node lifecycle management
- [ ] Consider VCR for caching real network responses
  - Set up VCR cassettes for repeatable tests
  - Filter sensitive data (API keys) from recordings

### Test Coverage Improvements
- [ ] Add tests for malformed JSON responses
- [ ] Add tests for network timeout scenarios
- [ ] Add tests for thread safety and concurrent requests
- [ ] Add tests for edge cases and boundary conditions
- [ ] Improve test documentation

## CI/CD

### GitHub Actions Workflows
- [ ] Create E2E test workflow
  - Schedule: Run daily or on-demand
  - Use GitHub Secrets for testnet RPC URLs
  - Report test results and failures
- [ ] Enhance existing CI workflow
  - Add build step
  - Add linting verification
  - Add test coverage reporting
  - Add security scanning (e.g., bundler-audit)

## Code Quality

### Client Implementation
- [ ] Add comprehensive input validation
  - Transaction hash format validation (0x-prefixed, 64 hex chars)
  - URL validation for RPC endpoints
  - Block number validation
- [ ] Add network timeout configuration
  - Make timeouts configurable via initialization
  - Document timeout defaults
  - Add timeout tests
- [ ] Implement retry logic with exponential backoff
  - Configure retry attempts and delays
  - Handle transient network failures gracefully
- [ ] Improve ID generation for thread safety
  - Consider using thread-safe counter or UUID
  - Add tests for concurrent request scenarios

### Error Handling
- [ ] Review and enhance error messages
- [ ] Add more specific exception types as needed
- [ ] Document all custom exceptions in README

## Security

### Security Enhancements
- [ ] Add URL scheme validation (HTTP/HTTPS only)
- [ ] Prevent SSRF vulnerabilities in URL handling
- [ ] Document security best practices
- [ ] Add guidance on sensitive data logging
- [ ] Consider rate limiting for API calls

## Performance

### Optimization Opportunities
- [ ] Benchmark client performance
- [ ] Optimize JSON parsing if needed
- [ ] Consider connection pooling for multiple requests
- [ ] Add performance documentation

## Additional Features

### Future Functionality
- [ ] Add more Ethereum JSON-RPC methods as needed
  - eth_getBalance
  - eth_getCode
  - eth_estimateGas
  - eth_sendRawTransaction
- [ ] Add batch request support
- [ ] Add WebSocket support for subscriptions
- [ ] Consider adding ENS resolution support
- [ ] Add gas price estimation utilities

## Documentation for Agents

### Agent Guidelines
- [ ] Document common patterns for agent implementations
- [ ] Add examples of agent-specific configurations
- [ ] Document testing strategies for agent code
- [ ] Add troubleshooting guide for agents

---

Last updated: 2025-11-03
