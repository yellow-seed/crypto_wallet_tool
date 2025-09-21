#!/bin/bash

# Open Ruby console in Docker
set -e

echo "💎 Opening Ruby console in Docker..."

docker-compose run --rm console
