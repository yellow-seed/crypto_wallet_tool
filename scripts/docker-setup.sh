#!/bin/bash

# Docker setup script for CryptoWalletTool
set -e

echo "🐳 Setting up Docker environment for CryptoWalletTool..."

# Build the Docker image
echo "📦 Building Docker image..."
docker-compose build

# Install dependencies
echo "📚 Installing dependencies..."
docker-compose run --rm app bundle install

echo "✅ Docker environment setup complete!"
echo ""
echo "Available commands:"
echo "  ./scripts/docker-test.sh     - Run tests"
echo "  ./scripts/docker-console.sh  - Open Ruby console"
echo "  ./scripts/docker-shell.sh    - Open shell in container"
echo "  ./scripts/docker-build.sh    - Build the gem"
