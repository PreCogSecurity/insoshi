# Dockerfile for Insoshi (Rails 2.3.x social networking engine)
# https://docs.docker.com/engine/reference/builder/
#
# Build: docker build -t insoshi .
# Run:   docker run -p 3000:3000 insoshi
#
# Note: This Dockerfile assumes the Rails app with its Gemfile, .
# config/database.yml, and public assets are present in the image.

# Use a base image with Ruby 2.0 compatible Rails stack
FROM ruby:2.0.0

# Install system dependencies needed for Rails/MySQL/Sphinx
RUN apt-get update && apt-get install -y \
    build-essential \
    nodejs \
    mysql-client \
    imagemagick \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /insoshi

# Install Ruby gems
COPY Gemfile /insoshi/Gemfile
COPY Gemfile.lock /insoshi/Gemfile.lock
RUN bundle install

# Copy the Rails application
COPY . /insoshi

# Expose the Rails server port
EXPOSE 3000

# Start the Rails server on all interfaces
# Unicorn or Puma would be preferred for production, but script/server works for development
CMD ["script", "server", "-b", "0.0.0.0"]