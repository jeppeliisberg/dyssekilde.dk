# Dyssekilde.dk

A Ruby on Rails 8.1 application for the Dyssekilde community.

## Requirements

- Ruby 3.3.6
- PostgreSQL 16+
- Node.js (for development tooling)

## Setup

```bash
# Install dependencies and prepare database
bin/setup

# Start development server
bin/dev
```

## Development

### Database

This application uses PostgreSQL. Make sure PostgreSQL is running locally:

```bash
# macOS with Homebrew
brew services start postgresql@16

# Create databases
bin/rails db:prepare
```

### Running Tests

```bash
# Run all tests
bin/rails test

# Run system tests
bin/rails test:system
```

### Code Quality

```bash
# Ruby style checking
bin/rubocop

# Auto-fix style issues
bin/rubocop -a

# Security scan
bin/brakeman --no-pager
```

## Architecture

- **Rails 8.1** with Hotwire (Turbo + Stimulus)
- **PostgreSQL** for primary database and Solid Stack services
- **Import Maps** for JavaScript (no build step)
- **Propshaft** asset pipeline
- **Kamal** for deployment

## Deployment

The application is deployed using Kamal with Docker:

```bash
bin/kamal deploy
```

See `config/deploy.yml` for deployment configuration.
