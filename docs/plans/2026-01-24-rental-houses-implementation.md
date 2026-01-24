# Rental Houses Resource Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a Spina resource for rental house listings with individual detail pages and collection display.

**Architecture:** Spina resource with custom parts for house data. Individual house pages at `/houses/<slug>`. Collection rendered via resource query on a dedicated "houses" view template.

**Tech Stack:** Spina CMS, Tailwind CSS, existing lightbox Stimulus controller for photo galleries.

**Skills to load:** `spina`, `rails-ai:views`, `rails-ai:testing`

---

## Task 1: Update Theme Configuration

**Files:**
- Modify: `config/initializers/themes/default.rb`

**Step 1: Add house parts to theme.parts array**

Add these parts after the existing `gallery_images` part (line 27):

```ruby
{ name: "house_name", title: "House Name", hint: "Friendly name like 'Cozy Cottage'", part_type: "Spina::Parts::Line" },
{ name: "house_description", title: "Description", part_type: "Spina::Parts::Text" },
{ name: "house_images", title: "Photos", part_type: "Spina::Parts::ImageCollection" },
{ name: "house_bedrooms", title: "Bedrooms", part_type: "Spina::Parts::Line" },
{ name: "house_bathrooms", title: "Bathrooms", part_type: "Spina::Parts::Line" },
{ name: "house_max_guests", title: "Max Guests", part_type: "Spina::Parts::Line" },
{ name: "house_sqm", title: "Square Meters", part_type: "Spina::Parts::Line" },
{ name: "house_pricing", title: "Pricing", part_type: "Spina::Parts::Line" },
{ name: "house_contact", title: "Contact", part_type: "Spina::Parts::MultiLine" }
```

**Step 2: Add house view template to theme.view_templates array**

Add after the `gallery` template (line 37):

```ruby
{ name: "house", title: "House", parts: %w[house_name house_description house_images house_bedrooms house_bathrooms house_max_guests house_sqm house_pricing house_contact] },
{ name: "houses", title: "Houses Collection", parts: %w[text] }
```

**Step 3: Add houses resource to theme.resources array**

Replace the empty array on line 62:

```ruby
theme.resources = [
  { name: "houses", label: "Rental Houses", view_template: "house", order_by: "title" }
]
```

**Step 4: Verify configuration loads**

Run: `bin/rails runner "puts Spina::Theme.find_by_name('default').view_templates.map { |t| t[:name] }.join(', ')"`

Expected: Should include `house` and `houses` in output.

**Step 5: Commit**

```bash
git add config/initializers/themes/default.rb
git commit -m "Add rental houses parts, view templates, and resource to Spina theme"
```

---

## Task 2: Create House Detail View

**Files:**
- Create: `app/views/default/pages/house.html.erb`

**Step 1: Create the house detail view**

```erb
<%
  # Collect image data for the lightbox (reuses existing lightbox controller)
  gallery_data = []
  images(:house_images) do |image|
    gallery_data << {
      url: content.image_url(image, resize_to_limit: [2048, 2048]),
      alt: image.alt.presence || current_page.title
    }
  end
%>

<article class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-16"
         data-controller="lightbox"
         data-lightbox-images-value="<%= gallery_data.to_json %>">
  <!-- Header -->
  <header class="mb-8">
    <% if content(:house_name).present? %>
      <p class="text-lg text-emerald-700 font-medium mb-2"><%= content(:house_name) %></p>
    <% end %>
    <h1 class="text-3xl md:text-4xl font-light text-stone-800 tracking-tight">
      <%= current_page.title %>
    </h1>
  </header>

  <!-- Photo gallery -->
  <% if gallery_data.any? %>
    <div class="mb-10">
      <div class="grid grid-cols-2 md:grid-cols-3 gap-2">
        <% index = 0 %>
        <% images(:house_images) do |image| %>
          <button type="button"
                  class="group relative aspect-square overflow-hidden rounded-lg bg-stone-200 cursor-pointer <%= index == 0 ? 'col-span-2 row-span-2' : '' %>"
                  data-action="lightbox#open"
                  data-index="<%= index %>">
            <%= content.image_tag image, { resize_to_fill: [600, 600] },
                { class: "absolute inset-0 w-full h-full object-cover transition-transform duration-300 group-hover:scale-105",
                  loading: index == 0 ? "eager" : "lazy" } %>
            <div class="absolute inset-0 bg-stone-900/0 group-hover:bg-stone-900/20 transition-colors duration-300"></div>
          </button>
          <% index += 1 %>
        <% end %>
      </div>
    </div>
  <% end %>

  <!-- Details grid -->
  <div class="grid grid-cols-2 md:grid-cols-4 gap-4 mb-10 p-6 bg-stone-100 rounded-lg">
    <% if content(:house_bedrooms).present? %>
      <div class="text-center">
        <p class="text-2xl font-light text-stone-800"><%= content(:house_bedrooms) %></p>
        <p class="text-sm text-stone-500">Soveværelser</p>
      </div>
    <% end %>
    <% if content(:house_bathrooms).present? %>
      <div class="text-center">
        <p class="text-2xl font-light text-stone-800"><%= content(:house_bathrooms) %></p>
        <p class="text-sm text-stone-500">Badeværelser</p>
      </div>
    <% end %>
    <% if content(:house_max_guests).present? %>
      <div class="text-center">
        <p class="text-2xl font-light text-stone-800"><%= content(:house_max_guests) %></p>
        <p class="text-sm text-stone-500">Max gæster</p>
      </div>
    <% end %>
    <% if content(:house_sqm).present? %>
      <div class="text-center">
        <p class="text-2xl font-light text-stone-800"><%= content(:house_sqm) %></p>
        <p class="text-sm text-stone-500">m²</p>
      </div>
    <% end %>
  </div>

  <!-- Description -->
  <% if content.html(:house_description).present? %>
    <div class="prose prose-stone prose-lg max-w-none mb-10">
      <%= content.html(:house_description) %>
    </div>
  <% end %>

  <!-- Pricing -->
  <% if content(:house_pricing).present? %>
    <div class="mb-10 p-6 bg-emerald-50 rounded-lg border border-emerald-100">
      <h2 class="text-lg font-medium text-stone-800 mb-2">Pris</h2>
      <p class="text-xl text-emerald-700"><%= content(:house_pricing) %></p>
    </div>
  <% end %>

  <!-- Contact -->
  <% if content(:house_contact).present? %>
    <div class="mb-10 p-6 bg-stone-100 rounded-lg">
      <h2 class="text-lg font-medium text-stone-800 mb-2">Kontakt</h2>
      <p class="text-stone-700 whitespace-pre-line"><%= content(:house_contact) %></p>
    </div>
  <% end %>

  <!-- Lightbox overlay (reuses existing pattern from gallery.html.erb) -->
  <div data-lightbox-target="overlay"
       data-action="click->lightbox#backdropClick"
       class="hidden fixed inset-0 z-50 bg-black/90 flex justify-center items-center">
    <button type="button"
            data-action="lightbox#close"
            class="absolute top-4 right-4 text-white text-2xl h-10 w-10 flex items-center justify-center bg-gray-900/50 rounded-full hover:bg-gray-900/70 transition-colors">
      <span class="sr-only">Luk</span>
      &times;
    </button>
    <button type="button"
            data-action="lightbox#previous"
            class="absolute left-4 text-white text-2xl h-10 w-10 flex items-center justify-center bg-gray-900/50 rounded-full hover:bg-gray-900/70 transition-colors">
      <span class="sr-only">Forrige</span>
      &larr;
    </button>
    <img data-lightbox-target="image" src="" alt="" class="max-w-full max-h-full object-contain p-4">
    <button type="button"
            data-action="lightbox#next"
            class="absolute right-4 text-white text-2xl h-10 w-10 flex items-center justify-center bg-gray-900/50 rounded-full hover:bg-gray-900/70 transition-colors">
      <span class="sr-only">Næste</span>
      &rarr;
    </button>
  </div>

  <!-- Back link -->
  <nav class="pt-8 border-t border-stone-200">
    <a href="<%= spina.page_path(Spina::Page.find_by(view_template: 'houses')) %>" class="group inline-flex items-center text-stone-800 hover:text-emerald-700 transition-colors">
      <svg class="mr-2 w-4 h-4 transform translate-x-0 group-hover:-translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
      </svg>
      <span class="text-lg">Tilbage til boliger</span>
    </a>
  </nav>
</article>
```

**Step 2: Verify file created**

Run: `ls -la app/views/default/pages/house.html.erb`

Expected: File exists.

**Step 3: Commit**

```bash
git add app/views/default/pages/house.html.erb
git commit -m "Add house detail view with photo gallery, details grid, and contact info"
```

---

## Task 3: Create Houses Collection View

**Files:**
- Create: `app/views/default/pages/houses.html.erb`

**Step 1: Create the houses collection view**

```erb
<%
  # Fetch all houses from the resource
  houses_resource = Spina::Resource.find_by(name: "houses")
  houses = houses_resource&.pages&.live&.sorted || []
%>

<article class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-12 md:py-16">
  <!-- Header -->
  <header class="mb-12 text-center">
    <h1 class="text-4xl md:text-5xl font-light text-stone-800 tracking-tight">
      <%= current_page.title %>
    </h1>
  </header>

  <!-- Introduction text -->
  <% if content.html(:text).present? %>
    <div class="prose prose-stone prose-lg max-w-3xl mx-auto mb-12">
      <%= content.html(:text) %>
    </div>
  <% end %>

  <!-- Houses grid -->
  <% if houses.any? %>
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
      <% houses.each do |house| %>
        <a href="<%= spina.page_path(house) %>" class="group block">
          <div class="bg-white rounded-lg overflow-hidden shadow-sm hover:shadow-md transition-shadow">
            <!-- Thumbnail image -->
            <div class="aspect-[4/3] bg-stone-200 overflow-hidden">
              <% house.images(:house_images) do |image| %>
                <%= house.content.image_tag image, { resize_to_fill: [600, 450] },
                    { class: "w-full h-full object-cover transition-transform duration-300 group-hover:scale-105" } %>
                <% break %> <%# Only show first image %>
              <% end %>
            </div>

            <!-- Content -->
            <div class="p-6">
              <% if house.content(:house_name).present? %>
                <p class="text-sm text-emerald-700 font-medium mb-1"><%= house.content(:house_name) %></p>
              <% end %>
              <h2 class="text-xl font-medium text-stone-800 mb-3 group-hover:text-emerald-700 transition-colors">
                <%= house.title %>
              </h2>

              <!-- Quick details -->
              <div class="flex flex-wrap gap-4 text-sm text-stone-500">
                <% if house.content(:house_bedrooms).present? %>
                  <span><%= house.content(:house_bedrooms) %> soveværelser</span>
                <% end %>
                <% if house.content(:house_sqm).present? %>
                  <span><%= house.content(:house_sqm) %> m²</span>
                <% end %>
              </div>

              <!-- Price -->
              <% if house.content(:house_pricing).present? %>
                <p class="mt-4 text-lg font-medium text-emerald-700"><%= house.content(:house_pricing) %></p>
              <% end %>
            </div>
          </div>
        </a>
      <% end %>
    </div>
  <% else %>
    <p class="text-center text-stone-500">Ingen boliger tilgængelige i øjeblikket.</p>
  <% end %>

  <!-- Back link -->
  <nav class="mt-12 pt-8 border-t border-stone-200">
    <a href="<%= spina.root_path %>" class="group inline-flex items-center text-stone-800 hover:text-emerald-700 transition-colors">
      <svg class="mr-2 w-4 h-4 transform translate-x-0 group-hover:-translate-x-1 transition-transform" fill="none" viewBox="0 0 24 24" stroke="currentColor">
        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
      </svg>
      <span class="text-lg">Tilbage til forsiden</span>
    </a>
  </nav>
</article>
```

**Step 2: Verify file created**

Run: `ls -la app/views/default/pages/houses.html.erb`

Expected: File exists.

**Step 3: Commit**

```bash
git add app/views/default/pages/houses.html.erb
git commit -m "Add houses collection view with card grid layout"
```

---

## Task 4: Add System Test for Houses

**Files:**
- Modify: `test/system/smoke_test.rb`

**Step 1: Add houses resource test**

Add this test after the existing `homepage loads successfully` test:

```ruby
test "houses collection page loads successfully" do
  # Create houses resource
  resource = Spina::Resource.find_or_create_by!(name: "houses") do |r|
    r.label = "Rental Houses"
  end

  # Create houses collection page
  houses_page = Spina::Page.find_or_create_by!(name: "houses") do |page|
    page.title = "Boliger"
    page.view_template = "houses"
    page.deletable = true
    page.position = 2
  end

  # Create a sample house
  house = Spina::Page.find_or_create_by!(name: "test-house") do |page|
    page.title = "Testvej 123"
    page.view_template = "house"
    page.resource = resource
    page.deletable = true
    page.position = 1
  end

  visit spina.page_path(houses_page)
  assert_no_text "We're sorry, but something went wrong"
  assert page.has_css?("body")
  assert page.has_text?("Boliger")
end

test "individual house page loads successfully" do
  # Create houses resource
  resource = Spina::Resource.find_or_create_by!(name: "houses") do |r|
    r.label = "Rental Houses"
  end

  # Create a sample house
  house = Spina::Page.find_or_create_by!(name: "test-house-detail") do |page|
    page.title = "Elmegade 42"
    page.view_template = "house"
    page.resource = resource
    page.deletable = true
    page.position = 1
  end

  visit spina.page_path(house)
  assert_no_text "We're sorry, but something went wrong"
  assert page.has_css?("body")
  assert page.has_text?("Elmegade 42")
end
```

**Step 2: Run tests**

Run: `bin/rails test:system`

Expected: All tests pass.

**Step 3: Commit**

```bash
git add test/system/smoke_test.rb
git commit -m "Add system tests for houses collection and detail pages"
```

---

## Task 5: Final Verification

**Step 1: Run full test suite**

Run: `bin/rails test && bin/rails test:system`

Expected: All tests pass.

**Step 2: Run linting**

Run: `bin/rubocop`

Expected: No offenses (or only pre-existing ones).

**Step 3: Start dev server and verify manually**

Run: `bin/dev`

Then in browser:
1. Visit `/admin` and log in
2. Check "Rental Houses" appears in sidebar
3. Create a test house with all fields filled
4. Create a page with "Houses Collection" template
5. View the collection page - house should appear
6. Click through to house detail - all content should display

**Step 4: Commit any fixes if needed**

If any issues found, fix and commit incrementally.
