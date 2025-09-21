# Use official Ruby image
FROM ruby:3.2-alpine

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apk add --no-cache \
    build-base \
    git \
    bash \
    curl

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install gems
RUN bundle config --global frozen 1 && \
    bundle install --without development test

# Copy the rest of the application
COPY . .

# Create a non-root user
RUN addgroup -g 1000 -S appgroup && \
    adduser -u 1000 -S appuser -G appgroup

# Change ownership of the app directory
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port (if needed for web services)
EXPOSE 3000

# Default command
CMD ["bundle", "exec", "irb"]
