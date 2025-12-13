# Swagger UI Preview

This document shows what the Swagger UI interface looks like when accessing http://localhost:3000/api-docs

## Swagger UI Interface

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                         CryptoWalletTool API v1                              ║
║                                                                              ║
║  API documentation for crypto_wallet_tool gem demonstration. This API       ║
║  provides endpoints for Ethereum blockchain interactions, text conversion   ║
║  utilities, and transaction debugging.                                       ║
║                                                                              ║
║  Server: http://localhost:3000                                              ║
╚══════════════════════════════════════════════════════════════════════════════╝

┌─ Converter ─────────────────────────────────────────────────────────────────┐
│                                                                              │
│  POST /api/v1/converter/uppercase                                           │
│  ▼ Convert text to uppercase                                                │
│                                                                              │
│  POST /api/v1/converter/lowercase                                           │
│  ▼ Convert text to lowercase                                                │
│                                                                              │
│  POST /api/v1/converter/reverse                                             │
│  ▼ Reverse text                                                             │
│                                                                              │
│  POST /api/v1/converter/title_case                                          │
│  ▼ Convert text to title case                                               │
│                                                                              │
│  POST /api/v1/converter/snake_case                                          │
│  ▼ Convert text to snake_case                                               │
│                                                                              │
│  POST /api/v1/converter/camel_case                                          │
│  ▼ Convert text to camelCase                                                │
└──────────────────────────────────────────────────────────────────────────────┘

┌─ Ethereum ──────────────────────────────────────────────────────────────────┐
│                                                                              │
│  POST /api/v1/ethereum/transaction                                          │
│  ▼ Get transaction by hash                                                  │
│                                                                              │
│  POST /api/v1/ethereum/receipt                                              │
│  ▼ Get transaction receipt                                                  │
│                                                                              │
│  POST /api/v1/ethereum/block_number                                         │
│  ▼ Get current block number                                                 │
│                                                                              │
│  POST /api/v1/ethereum/call                                                 │
│  ▼ Execute eth_call                                                         │
└──────────────────────────────────────────────────────────────────────────────┘

┌─ Transaction Debugger ──────────────────────────────────────────────────────┐
│                                                                              │
│  POST /api/v1/debug/transaction                                             │
│  ▼ Analyze transaction with debugging info                                  │
│                                                                              │
│  POST /api/v1/debug/receipt                                                 │
│  ▼ Analyze transaction receipt with debugging info                          │
└──────────────────────────────────────────────────────────────────────────────┘
```

## Example: Expanded Endpoint View

When you click on an endpoint (e.g., "POST /api/v1/converter/uppercase"), you'll see:

```
╔══════════════════════════════════════════════════════════════════════════════╗
║  POST /api/v1/converter/uppercase                                           ║
║  Convert text to uppercase                                                  ║
╚══════════════════════════════════════════════════════════════════════════════╝

┌─ Parameters ─────────────────────────────────────────────────────────────────┐
│                                                                              │
│  text * (query)          [string]                                           │
│  Text to convert to uppercase                                               │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ hello world                                                            │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
│                                                                              │
└──────────────────────────────────────────────────────────────────────────────┘

                              [Try it out] [Execute]

┌─ Responses ──────────────────────────────────────────────────────────────────┐
│                                                                              │
│  Code  Description                                                          │
│  200   successful                                                           │
│        Response body:                                                       │
│        {                                                                    │
│          "input": "string",                                                 │
│          "output": "string"                                                 │
│        }                                                                    │
│                                                                              │
│  400   bad request                                                          │
│        Response body:                                                       │
│        {                                                                    │
│          "error": "string"                                                  │
│        }                                                                    │
└──────────────────────────────────────────────────────────────────────────────┘
```

## After Clicking "Execute"

```
┌─ Responses ──────────────────────────────────────────────────────────────────┐
│                                                                              │
│  Server response                                                            │
│  ┌────────────────────────────────────────────────────────────────────────┐ │
│  │ Code: 200                                                              │ │
│  │                                                                        │ │
│  │ Response body:                                                         │ │
│  │ {                                                                      │ │
│  │   "input": "hello world",                                              │ │
│  │   "output": "HELLO WORLD"                                              │ │
│  │ }                                                                      │ │
│  │                                                                        │ │
│  │ Response headers:                                                      │ │
│  │ content-type: application/json; charset=utf-8                          │ │
│  │ x-request-id: abc123                                                   │ │
│  └────────────────────────────────────────────────────────────────────────┘ │
└──────────────────────────────────────────────────────────────────────────────┘
```

## Features Available in Swagger UI

1. **Interactive Testing**: Click "Try it out" to enable parameter editing, then "Execute" to send a real request to the API

2. **Response Visualization**: See the actual HTTP response code, headers, and body immediately after execution

3. **Schema Documentation**: View detailed schemas for request and response bodies

4. **Grouped Endpoints**: APIs are organized by tags (Converter, Ethereum, Transaction Debugger)

5. **Example Values**: Pre-filled example values help you understand the expected format

6. **Model Documentation**: Click on schema types to see the full structure

## Accessing Swagger UI

1. Start the Rails server:
   ```bash
   # Using Docker
   docker compose up
   
   # Or locally
   bundle install
   bin/rails server
   ```

2. Open your browser and navigate to:
   ```
   http://localhost:3000/api-docs
   ```

3. The Swagger UI will load automatically with all API documentation

## Benefits of Using Swagger UI

- **No API Client Required**: Test APIs directly from your browser
- **Always Up-to-Date**: Documentation is generated from the actual API definition
- **Clear Examples**: See request/response examples for every endpoint
- **Error Handling**: Understand what errors can occur and their format
- **Quick Testing**: Rapidly test different parameters without writing code
