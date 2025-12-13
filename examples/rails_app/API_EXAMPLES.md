# API Usage Examples

This document provides curl examples for testing the CryptoWalletTool API endpoints.

## Prerequisites

Make sure the Rails server is running:

```bash
# Option 1: Using Docker Compose
docker compose up

# Option 2: Local development
bundle install
bin/rails server
```

## Converter API Examples

### Uppercase Conversion

```bash
curl -X POST "http://localhost:3000/api/v1/converter/uppercase?text=hello%20world"
```

Response:
```json
{
  "input": "hello world",
  "output": "HELLO WORLD"
}
```

### Lowercase Conversion

```bash
curl -X POST "http://localhost:3000/api/v1/converter/lowercase?text=HELLO%20WORLD"
```

### Reverse Text

```bash
curl -X POST "http://localhost:3000/api/v1/converter/reverse?text=hello"
```

Response:
```json
{
  "input": "hello",
  "output": "olleh"
}
```

### Title Case Conversion

```bash
curl -X POST "http://localhost:3000/api/v1/converter/title_case?text=hello%20world"
```

### Snake Case Conversion

```bash
curl -X POST "http://localhost:3000/api/v1/converter/snake_case?text=helloWorld"
```

Response:
```json
{
  "input": "helloWorld",
  "output": "hello_world"
}
```

### Camel Case Conversion

```bash
curl -X POST "http://localhost:3000/api/v1/converter/camel_case?text=hello_world"
```

Response:
```json
{
  "input": "hello_world",
  "output": "helloWorld"
}
```

## Ethereum API Examples

**Note**: These endpoints require the `ETHEREUM_RPC_URL` environment variable to be set.

### Get Transaction by Hash

```bash
export ETHEREUM_RPC_URL="https://mainnet.infura.io/v3/YOUR_PROJECT_ID"

curl -X POST "http://localhost:3000/api/v1/ethereum/transaction?transaction_hash=0x..."
```

### Get Transaction Receipt

```bash
curl -X POST "http://localhost:3000/api/v1/ethereum/receipt?transaction_hash=0x..."
```

### Get Current Block Number

```bash
curl -X POST "http://localhost:3000/api/v1/ethereum/block_number"
```

Response:
```json
{
  "block_number": 12345678
}
```

### Execute eth_call

```bash
curl -X POST "http://localhost:3000/api/v1/ethereum/call?block=latest" \
  -H "Content-Type: application/json" \
  -d '{
    "to": "0x...",
    "data": "0x..."
  }'
```

## Transaction Debugger API Examples

**Note**: These endpoints require the `ETHEREUM_RPC_URL` environment variable to be set.

### Analyze Transaction

```bash
curl -X POST "http://localhost:3000/api/v1/debug/transaction?transaction_hash=0x..."
```

Response:
```json
{
  "hash": "0x...",
  "from": "0x...",
  "to": "0x...",
  "value": 0,
  "gas": 21000,
  "gas_price": 1000000000,
  "eip1559": false,
  "raw_data": { ... }
}
```

### Analyze Transaction Receipt

```bash
curl -X POST "http://localhost:3000/api/v1/debug/receipt?transaction_hash=0x..."
```

Response:
```json
{
  "transaction_hash": "0x...",
  "status": "success",
  "success": true,
  "failed": false,
  "block_number": 12345678,
  "gas_used": 21000,
  "raw_data": { ... }
}
```

## Error Handling

### Missing Parameters

```bash
curl -X POST "http://localhost:3000/api/v1/converter/uppercase"
```

Response (400):
```json
{
  "error": "param is missing or the value is empty: text"
}
```

### RPC Endpoint Not Configured

```bash
# Without ETHEREUM_RPC_URL set
curl -X POST "http://localhost:3000/api/v1/ethereum/block_number"
```

Response (503):
```json
{
  "error": "ETHEREUM_RPC_URL environment variable is not set. Please configure an Ethereum RPC endpoint."
}
```

## Using Swagger UI

For an interactive API documentation and testing interface, visit:

```
http://localhost:3000/api-docs
```

The Swagger UI allows you to:
- Browse all available endpoints
- View request/response schemas
- Test endpoints directly from the browser
- See example values and descriptions
