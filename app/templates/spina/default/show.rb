# frozen_string_literal: true

Spina.define_template "show" do
  title "Page"

  part "hero_image", :image, title: "Hero Image", hint: "Full-height image shown on the left side"
  part "text", :text, title: "Body", hint: "Your main content"
end
