# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DyssekildeDk is a Ruby on Rails 8.1.2 application using SQLite3, Hotwire (Turbo + Stimulus), and Import Maps for JavaScript.

## Common Commands

### Development
- `bin/setup` - Install dependencies and prepare database
- `bin/dev` - Start development server

### Testing
- `bin/rails test` - Run unit/integration tests
- `bin/rails test test/path/to/file_test.rb` - Run a single test file
- `bin/rails test test/path/to/file_test.rb:42` - Run a specific test by line number
- `bin/rails test:system` - Run system tests (Capybara/Selenium)

### Linting & Security
- `bin/rubocop` - Ruby style checking (Omakase Rails style)
- `bin/rubocop -a` - Auto-fix style issues
- `bin/brakeman --no-pager` - Security vulnerability scan
- `bin/bundler-audit` - Gem vulnerability check
- `bin/importmap audit` - JavaScript dependency audit

### Database
- `bin/rails db:prepare` - Create or migrate database
- `bin/rails db:migrate` - Run pending migrations

## Architecture

**Frontend Stack:**
- Hotwire for SPA-like behavior (Turbo Drive, Frames, Streams)
- Stimulus controllers in `app/javascript/controllers/`
- Import Maps (no JS build step) - configure in `config/importmap.rb`
- Propshaft asset pipeline

**Backend Services (Solid Stack):**
- Solid Queue for background jobs (separate SQLite database)
- Solid Cache for caching (separate SQLite database)
- Solid Cable for Action Cable (separate SQLite database)

**Deployment:**
- Docker multi-stage builds with Kamal orchestration
- Configuration in `config/deploy.yml` and `.kamal/secrets`
- `bin/kamal deploy` for production deployment
