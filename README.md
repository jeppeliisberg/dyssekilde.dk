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

The application is deployed using Kamal with Docker to a Cloudron-managed server.

### Non-Standard Setup

This deployment differs from a typical Kamal setup in several ways:

| Aspect | Standard Kamal | This Project |
|--------|---------------|--------------|
| HTTP Proxy | kamal-proxy handles routing | Cloudron proxy app (kamal-proxy disabled) |
| Port binding | Dynamic ports via proxy | Fixed port 3080 bound to localhost |
| Zero-downtime | Built-in via proxy | Brief downtime (~5s) during deploys |
| SSL/TLS | kamal-proxy or separate config | Handled by Cloudron |

### Why This Setup?

The server runs Cloudron, which manages its own nginx reverse proxy for all apps. Using kamal-proxy alongside Cloudron's proxy would create conflicts, so:

- `proxy: false` is set in `config/deploy.yml`
- The Rails container binds directly to `127.0.0.1:3080`
- Cloudron's proxy app forwards traffic to port 3080

### Deploying

**Always use the safe deploy script:**

```bash
bin/safe-deploy
```

This script:
1. Stops the old container (freeing port 3080)
2. Runs `bin/kamal deploy`
3. If deploy fails, automatically restarts the old container
4. If deploy succeeds, cleans up old stopped containers

**Do not use `bin/kamal deploy` directly** - it will fail with a port conflict because the old container is still running.

### Other Kamal Commands

```bash
bin/kamal console    # Rails console on production
bin/kamal shell      # Bash shell in production container
bin/kamal logs       # Tail production logs
bin/kamal dbc        # Database console
```

See `config/deploy.yml` for full deployment configuration.
