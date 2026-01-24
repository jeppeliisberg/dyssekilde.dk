# Theme configuration file
# ========================
# This file is used for all theme configuration.
# It's where you define everything that's editable in Spina CMS.

Spina::Theme.register do |theme|
  # All views are namespaced based on the theme's name
  theme.name = "default"
  theme.title = "Default theme"

  # Parts
  # Define all editable parts you want to use in your view templates
  #
  # Built-in part types:
  # - Line
  # - MultiLine
  # - Text (Rich text editor)
  # - Image
  # - ImageCollection
  # - Attachment
  # - Option
  # - Repeater
  theme.parts = [
    { name: "text", title: "Body", hint: "Your main content", part_type: "Spina::Parts::Text" },
    { name: "subtitle", title: "Subtitle", hint: "Shown below the page title", part_type: "Spina::Parts::Line" },
    { name: "hero_image", title: "Hero Image", hint: "Full-height image shown on the left side", part_type: "Spina::Parts::Image" },
    { name: "gallery_images", title: "Gallery Images", hint: "Images for the gallery grid", part_type: "Spina::Parts::ImageCollection" },
    { name: "house_name", title: "House Name", hint: "Friendly name like 'Cozy Cottage'", part_type: "Spina::Parts::Line" },
    { name: "house_description", title: "Description", part_type: "Spina::Parts::Text" },
    { name: "house_images", title: "Photos", part_type: "Spina::Parts::ImageCollection" },
    { name: "house_bedrooms", title: "Bedrooms", part_type: "Spina::Parts::Line" },
    { name: "house_bathrooms", title: "Bathrooms", part_type: "Spina::Parts::Line" },
    { name: "house_max_guests", title: "Max Guests", part_type: "Spina::Parts::Line" },
    { name: "house_sqm", title: "Square Meters", part_type: "Spina::Parts::Line" },
    { name: "house_pricing", title: "Pricing", part_type: "Spina::Parts::Line" },
    { name: "house_contact", title: "Contact", part_type: "Spina::Parts::MultiLine" },
    { name: "og_image", title: "Social Share Image", hint: "Image shown when page is shared on social media (1200x630 recommended)", part_type: "Spina::Parts::Image" }
  ]

  # View templates
  # Every page has a view template stored in app/views/my_theme/pages/*
  # You define which parts you want to enable for every view template
  # by referencing them from the theme.parts configuration above.
  theme.view_templates = [
    { name: "homepage", title: "Homepage", parts: %w[hero_image subtitle text] },
    { name: "show", title: "Page", parts: %w[hero_image text] },
    { name: "gallery", title: "Gallery", parts: %w[text gallery_images] },
    { name: "house", title: "House", parts: %w[house_name house_description house_images house_bedrooms house_bathrooms house_max_guests house_sqm house_pricing house_contact] },
    { name: "houses", title: "Houses Collection", parts: %w[text og_image] }
  ]

  # Custom pages
  # Some pages should not be created by the user, but generated automatically.
  # By naming them you can reference them in your code.
  theme.custom_pages = [
    { name: "homepage", title: "Homepage", deletable: false, view_template: "homepage" }
  ]

  # Navigations (optional)
  # If your project has multiple navigations, it can be useful to configure multiple
  # navigations.
  theme.navigations = [
    { name: "main", label: "Main navigation" }
  ]

  # Layout parts (optional)
  # You can create global content that doesn't belong to one specific page. We call these layout parts.
  # You only have to reference the name of the parts you want to have here.
  theme.layout_parts = []

  # Resources (optional)
  # Think of resources as a collection of pages. They are managed separately in Spina
  # allowing you to separate these pages from the 'main' collection of pages.
  theme.resources = [
    { name: "houses", label: "Rental Houses", view_template: "house", order_by: "title" }
  ]

  # Plugins (optional)
  theme.plugins = []

  # Embeds (optional)
  theme.embeds = []
end
