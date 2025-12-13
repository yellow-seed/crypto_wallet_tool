# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.2.9
FROM docker.io/library/ruby:$RUBY_VERSION

# Rails app lives here
WORKDIR /rails

# Install base packages for development
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libpq-dev \
    libvips \
    pkg-config \
    postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set development environment
ENV RAILS_ENV="development" \
    BUNDLE_PATH="/usr/local/bundle" \
    CRYPTO_WALLET_TOOL_PATH="/gem"

# Copy the gem files from the repository root
COPY crypto_wallet_tool.gemspec /gem/
COPY lib /gem/lib/
COPY Gemfile /gem/
COPY Gemfile.lock /gem/

# Copy Rails app Gemfile
COPY examples/rails_app/Gemfile examples/rails_app/Gemfile.lock ./

# Install application gems
RUN bundle install --jobs 4 --retry 3

# Copy application code
COPY examples/rails_app .

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]
