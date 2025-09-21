#!/bin/bash

# Open shell in Docker container
set -e

echo "🐚 Opening shell in Docker container..."

docker-compose run --rm app /bin/bash
