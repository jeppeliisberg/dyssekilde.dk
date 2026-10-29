# frozen_string_literal: true

# Page templates (parts per view template) are defined in
# app/templates/spina/default/*.rb using Spina.define_template.
Spina::Theme.register do |theme|
  theme.name = "default"
  theme.title = "Default theme"
  theme.load_templates_from "app/templates/spina/default"

  theme.custom_pages = [
    { name: "homepage", title: "Homepage", deletable: false, view_template: "homepage" }
  ]

  theme.navigations = [
    { name: "main", label: "Main navigation" },
    { name: "footer", label: "Footer navigation" }
  ]

  theme.resources = [
    { name: "houses", label: "Rental Houses", view_template: "house", order_by: "title" }
  ]

  # Explicitly no plugins (nil would enable every registered Spina plugin)
  theme.plugins = []
end
