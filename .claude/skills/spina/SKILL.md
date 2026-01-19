---
name: spina
description: Use when working with Spina CMS - themes, parts, view templates, content rendering, ViewComponents, API
---

# Spina CMS (Ruby on Rails) — Theme + Content Modeling + API

> **Version note:** This skill assumes **Spina 2.x**. Spina 1.x has significant differences in theming and part definitions.

## Purpose
Help me correctly understand, navigate, and modify a Rails app that uses **Spina CMS**:
- Install/upgrade Spina and its dependencies (notably ActiveStorage)
- Define and evolve **themes** (parts, view templates, layout parts, navigations, custom pages, resources)
- Render content correctly in Rails views or ViewComponents (Line, MultiLine, Rich Text, Images, Attachments, Options, Repeaters)
- Extend Spina (custom parts, embeds, ViewComponents)
- Enable and consume Spina’s (beta) JSON API, including pagination and authentication
- Avoid common pitfalls (N+1 queries in custom parts, SVG handling, Tailwind build integration)

## When to use this skill
Use this skill when the user asks for any of:
- “Set up Spina CMS in my Rails app”, “add Spina to an existing project”
- “How do themes/parts/view templates work in Spina?”
- “How do I render content(:x) / content.html(:x) / images(:x)?”
- “Create a repeater / nested content block”
- "Create custom part / embed component"
- "Use ViewComponent with Spina"
- “Enable the Spina API and fetch pages/navigations/resources/images”
- “Integrate Spina admin auth with my existing authentication”
- “Spina Tailwind / assets:precompile issues”
- “Allow SVG uploads safely”

## Mental model (what Spina is doing)
- **Theme** is configured in an initializer (commonly `config/initializers/themes/default.rb`).
- A **Page** has many **parts**, and the selected **view_template** determines which parts appear for that page.
- **Layout parts** are global content stored on the Account and rendered via `current_account.content`.
- **Navigations** are optional collections of pages (separate from the main page tree).
- **Resources** are page-like collections managed separately from regular pages (useful for blog/SEO/team lists).
- Content is stored in a single JSONB column; custom parts and default parts are modeled as JSON objects.

## Key files & where to look
1) Spina initializer:
- `config/initializers/spina.rb` (Spina.configure, API key, auth module, etc.)

2) Theme initializer:
- `config/initializers/themes/default.rb` (or similar)
- Defines:
  - `theme.parts`
  - `theme.view_templates`
  - `theme.custom_pages`
  - `theme.navigations`
  - `theme.layout_parts`
  - `theme.resources`
  - `theme.embeds`
  - (and optionally plugins)

3) Frontend views (generated per theme):
- `app/views/<theme_name>/pages/homepage.html.erb`
- `app/views/<theme_name>/pages/show.html.erb`

4) Admin overrides / custom part forms:
- `app/views/spina/admin/parts/<part_plural>/_form.html.erb`

5) Custom parts:
- `app/models/spina/parts/<part>.rb`

6) Embed overrides:
- `app/views/spina/embeds/...`

7) ViewComponents (if using component-based rendering):
- `app/components/` (your custom components)
- Spina uses ViewComponent internally for admin UI

8) Tailwind build artifacts:
- `app/assets/config/spina/tailwind.config.js`
- `app/assets/builds/spina/tailwind.css`

## Common tasks (playbooks)

### A) Install Spina into a new Rails app
1. Ensure Rails app uses Postgres.
2. Install ActiveStorage:
   - `rails active_storage:install`
   - run migrations
3. Add to Gemfile:
   - `gem "spina"`
4. Run:
   - `bundle install`
   - `rails spina:install`
5. Visit:
   - `/admin`

### B) Add or change page parts
Goal: Add a new field/part to the editor and render it on the site.

1) Edit theme initializer parts array:
- Add a part object, e.g. another `Spina::Parts::Text` or a `Spina::Parts::Image`.

2) Ensure the part name is included in the relevant view_template’s `parts: %w(...)`.

3) Render the part in the corresponding view file using the right helper:
- Line / MultiLine / Option:
  - `<%= content(:headline) %>`
- Rich Text (HTML):
  - `<%= content.html(:main_content) %>`
- Image:
  - `content.image_tag(:header_image, variant: :medium, class: "...")` for `<img>` tag
  - `content.image_url(:header_image, variant: :medium)` for just the URL
- Image collection:
  - `images(:cars) do |image|`
- Attachment:
  - `<%= content.attachment_url(:file) %>`
- Repeater:
  - Iterate the repeater items and render nested parts

Tip: Keep part count minimal to avoid editor complexity.

### C) Create a new view template
Goal: Add a new page type (e.g., "Contact", "Landing Page") with its own set of parts.

1) Define the view template in theme initializer:
```ruby
theme.view_templates = [
  # ... existing templates ...
  {
    name: "contact",
    title: "Contact Page",
    parts: %w[headline intro_text address phone email contact_form_enabled]
  }
]
```

2) Ensure all referenced parts exist in `theme.parts`.

3) Create the view file:
- `app/views/<theme_name>/pages/contact.html.erb`

4) Optionally, create a ViewComponent instead of an ERB template:
- `app/components/pages/contact_component.rb`
- Render from view: `<%= render Pages::ContactComponent.new(page: current_page) %>`

### D) Create repeating (nested) content with a Repeater
1) Define a `Spina::Parts::Repeater` in theme parts:
- Provide `parts: %w(child_part_a child_part_b ...)`
2) Render in a view by iterating repeater items.
3) Nesting can include custom parts too.

### E) Add a global layout part (e.g., footer)
1) Define the part in `theme.parts`.
2) Add its name to `theme.layout_parts = %w(footer)`
3) Render on frontend via:
- `current_account.content`

### F) Configure navigations
1) In theme initializer define:
- `name`, `label`, and optionally `auto_add_pages: true`
2) Use navigation data for menus.
Note: Sitemap/friendly URLs are based on the main page overview, not navigations.

### G) Use Resources (blog-like collections without a plugin)
1) Create resource record:
- `Spina::Resource.create(name: "blogposts", label: "Blogposts")`
2) Fetch:
- `Spina::Resource.find_by(name: "blogposts").pages`
3) Distinguish page types:
- `Spina::Page.regular_pages`
- `Spina::Page.resource_pages`
4) Configure resource attributes:
- `name`, `label`, `view_template`, `order_by`, `slug`

### H) Create a custom Part type (stored in JSONB)
Use when a standard part is insufficient (e.g., selecting a Movie record).

**Dependency:** Spina uses the `attr_json` gem for JSONB attribute handling.

1) Create model:
- `app/models/spina/parts/movie.rb`
- inherit from `Spina::Parts::Base`
- use `attr_json` to define stored attributes
- implement `content` method

Performance guidance:
- Avoid N+1 queries when `content` hits the DB; prefer storing required data directly in JSON where feasible.
- Use `find_by` to avoid raising RecordNotFound.

2) Create admin form partial:
- `app/views/spina/admin/parts/movies/_form.html.erb`
- Use form builder to edit attributes.

3) Register the part in an initializer:
- `Rails.application.reloader.to_prepare do`
- `Spina::Part.register(Spina::Parts::Movie)`
- `end`

4) Use in template:
- `content(:movie)` (or `content(:movie)[:director]` depending on what `content` returns)

### I) Rich text embeds in Trix
1) Enable built-in embeds in the theme initializer:
- `theme.embeds = %w(button youtube vimeo)`
2) Override rendering templates if desired:
- `app/views/spina/embeds/buttons/_button.html.erb`
- `app/views/spina/embeds/youtubes/_youtube.html.erb`
- `app/views/spina/embeds/vimeos/_vimeo.html.erb`

3) Create your own embed:
- `rails g spina:embed my_component some_attribute another_attribute`
- Implement `heroicon`, validations, and provide:
  - `_my_component_fields.html.erb` (editor UI)
  - `_my_component.html.erb` (frontend rendering)

### J) Use existing app authentication for Spina admin
If Spina’s default `Spina::User` isn’t desired:

1) Create an auth module with:
- `authenticate`
- `logged_in?`
(and typically `current_user`)

2) Configure in `config/initializers/spina.rb`:
- `config.authentication = "MyApp::CustomAuth"`

### K) Enable Spina API (beta) and consume it
1) Set API key in initializer:
- `config.api_key = Rails.application.credentials.spina_api_key`

2) Pagination:
- List endpoints include `meta` + `links` (first/prev/next/last)
- Follow `links.next` until null.

3) Core endpoints:
- `/api/pages.json`
- `/api/navigations.json`
- `/api/resources.json`
- `/api/images/{id}.json` (currently returns a few prebuilt URLs)

Implementation advice:
- Put the API key in Rails credentials, not environment variables committed to repo.
- Wrap API access with a small client object (Faraday/Net::HTTP) and handle pagination generically.

### L) Tailwind integration considerations
Spina's released gem uses Tailwind 3 via `tailwindcss-rails`, and hooks into `assets:precompile`:
- Collect scan paths from `Spina.config.tailwind_content`
- Generate `app/assets/config/spina/tailwind.config.js`
- Build Tailwind to `app/assets/builds/spina/tailwind.css`

**Tailwind 4 compatibility:** To use Tailwind 4, install Spina from GitHub source:
```ruby
gem "spina", github: "SpinaCMS/Spina", branch: "main"
```

When debugging missing styles:
- Check whether the content scan paths include your overrides.
- Confirm precompile runs in deploy environment.

### M) SVG uploads safely
Rails serves SVG as attachment by default due to XSS risk.
To allow `<img>` usage:
- Remove `image/svg+xml` from the "serve as binary" list in an initializer.
- If end-users can upload SVGs, add an SVG sanitizer gem and sanitize.

### N) Using ViewComponent with Spina
Spina uses ViewComponent internally for its admin UI. You can also use ViewComponent for your frontend page rendering.

1) Create a component for a page template:
```ruby
# app/components/pages/homepage_component.rb
class Pages::HomepageComponent < ViewComponent::Base
  def initialize(page:)
    @page = page
  end

  # Delegate content helpers to the page
  delegate :content, :images, to: :@page
end
```

2) Create the component template:
- `app/components/pages/homepage_component.html.erb`

3) Render from the Spina view:
```erb
<%# app/views/default/pages/homepage.html.erb %>
<%= render Pages::HomepageComponent.new(page: current_page) %>
```

Benefits:
- Better encapsulation and testability
- Previews with ViewComponent previews
- Consistent with modern Rails patterns
- Spina's content helpers work via delegation

## Guardrails (don't do these)
- Don’t add lots of parts “because we can” — it hurts editor usability.
- Don’t implement custom parts that query per item without considering N+1.
- Don’t enable SVG rendering without a sanitization plan if users can upload SVGs.
- Don’t hardcode API keys in code or in plaintext config files.

## Quick reference: rendering helpers
- Line / MultiLine / Option:
  - `content(:name)`
- Rich text:
  - `content.html(:name)`
- Image:
  - `content.image_tag(:name, ...)` OR `content.image_url(:name, ...)`
- Image collection:
  - `images(:name) { |image| ... }`
- Attachment:
  - `content.attachment_url(:name)`

## What I should ask the user (minimal, only if needed)
- “Is your Spina theme named `default` or something else?”
- “Are you using Spina as a full CMS site, or headless via the API?”
- “Do editors upload images/files (ActiveStorage already installed/configured)?”
- “Any custom auth (Devise/etc.) we need to integrate with Spina admin?”
