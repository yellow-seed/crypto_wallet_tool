#!/bin/bash

# Run tests in Docker
set -e

echo "🧪 Running tests in Docker..."

docker-compose run --rm test

echo "✅ Tests completed!"
