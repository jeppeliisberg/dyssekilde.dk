# Meta Tags Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add proper meta tags (title, description, Open Graph, Twitter) to all Spina pages with smart image and content fallbacks.

**Architecture:** Helper module in ApplicationHelper to compute meta values, called from layout. No gems needed.

**Tech Stack:** Rails helpers, ActiveStorage variants, Spina CMS content helpers.

**Skills to load:** `spina`, `rails-ai:views`

---

## Task 1: Add og_image Part to Theme

**Files:**
- Modify: `config/initializers/themes/default.rb`

**Changes:**
1. Add `og_image` part to theme.parts:
```ruby
{ name: "og_image", title: "Social Share Image", hint: "Image shown when page is shared on social media (1200x630 recommended)", part_type: "Spina::Parts::Image" }
```

2. Add `og_image` to the `houses` view template parts array.

**Commit:** `git commit -m "Add og_image part for social media sharing"`

---

## Task 2: Create Meta Tags Helper

**Files:**
- Modify: `app/helpers/application_helper.rb`

**Create these helper methods:**

```ruby
def meta_title
  return current_page.seo_title if current_page.seo_title.present?
  "#{current_page.title} | #{current_spina_account.name}"
end

def meta_description
  return current_page.seo_description if current_page.seo_description.present?

  # Try to extract from page content
  text = extract_page_text
  return nil if text.blank?

  truncate(strip_tags(text), length: 162, separator: ' ', omission: '...')
end

def og_image_url
  image = find_og_image
  return nil unless image

  # Generate 1200x630 variant URL
  url_for(image.file.variant(resize_to_fill: [1200, 630]))
end

private

def extract_page_text
  # Try different content parts based on what's available
  [:text, :house_description].each do |part_name|
    text = current_page.content(part_name)
    return text if text.present?
  end
  nil
end

def find_og_image
  # Check single image parts first
  [:hero_image, :og_image].each do |part_name|
    image = current_page.content(part_name)
    return image if image.present?
  end

  # Check image collections - take first image
  [:gallery_images, :house_images].each do |part_name|
    part = current_page.find_part(part_name)
    if part&.images&.any?
      return part.images.first
    end
  end

  nil
end
```

**Commit:** `git commit -m "Add meta tags helper methods for SEO and social sharing"`

---

## Task 3: Update Layout with Meta Tags

**Files:**
- Modify: `app/views/layouts/default/application.html.erb`

**Replace the `<head>` section with:**

```erb
<head>
  <title><%= meta_title %></title>
  <meta name="viewport" content="width=device-width,initial-scale=1">
  <meta charset="utf-8">

  <% if meta_description.present? %>
    <meta name="description" content="<%= meta_description %>">
  <% end %>

  <%# Open Graph %>
  <meta property="og:title" content="<%= meta_title %>">
  <meta property="og:type" content="website">
  <meta property="og:url" content="<%= request.original_url %>">
  <% if meta_description.present? %>
    <meta property="og:description" content="<%= meta_description %>">
  <% end %>
  <% if og_image_url.present? %>
    <meta property="og:image" content="<%= og_image_url %>">
    <meta property="og:image:width" content="1200">
    <meta property="og:image:height" content="630">
  <% end %>
  <meta property="og:site_name" content="<%= current_spina_account.name %>">
  <meta property="og:locale" content="<%= I18n.locale %>">

  <%# Twitter Card %>
  <meta name="twitter:card" content="<%= og_image_url.present? ? 'summary_large_image' : 'summary' %>">
  <meta name="twitter:title" content="<%= meta_title %>">
  <% if meta_description.present? %>
    <meta name="twitter:description" content="<%= meta_description %>">
  <% end %>
  <% if og_image_url.present? %>
    <meta name="twitter:image" content="<%= og_image_url %>">
  <% end %>

  <%= csrf_meta_tags %>
  <%= csp_meta_tag %>
  <%= stylesheet_link_tag "tailwind", "data-turbo-track": "reload" %>
  <%= javascript_importmap_tags %>
</head>
```

**Commit:** `git commit -m "Add Open Graph and Twitter meta tags to layout"`

---

## Task 4: Add Tests

**Files:**
- Create: `test/helpers/application_helper_test.rb`

**Test cases:**
1. `meta_title` returns seo_title when present
2. `meta_title` falls back to page title with site name
3. `meta_description` returns seo_description when present
4. `meta_description` truncates text content to 162 chars
5. `og_image_url` returns hero_image URL when present
6. `og_image_url` returns first gallery image when no hero_image

**Commit:** `git commit -m "Add tests for meta tags helper"`

---

## Task 5: Final Verification

**Steps:**
1. Run `bin/rails test` - all tests pass
2. Run `bin/rubocop` - no offenses
3. Start `bin/dev` and verify:
   - Homepage has correct meta tags
   - Gallery page uses first gallery image
   - House page uses first house image
   - View page source to confirm tags are correct

**Commit any fixes if needed.**
