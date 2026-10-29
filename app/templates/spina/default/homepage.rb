# frozen_string_literal: true

Spina.define_template "homepage" do
  part "hero_image", :image, title: "Hero Image", hint: "Full-height image shown on the left side"
  part "subtitle", :line, hint: "Shown below the page title"
  part "text", :text, title: "Body", hint: "Your main content"
end
