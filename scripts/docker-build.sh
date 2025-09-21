#!/bin/bash

# Build the gem in Docker
set -e

echo "🔨 Building gem in Docker..."

docker-compose run --rm build

echo "✅ Gem build completed!"
echo "📦 Gem file created in pkg/ directory"
