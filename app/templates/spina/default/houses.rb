# frozen_string_literal: true

Spina.define_template "houses" do
  title "Houses Collection"

  part "text", :text, title: "Body", hint: "Your main content"
  part "og_image", :image, title: "Social Share Image", hint: "Image shown when page is shared on social media (1200x630 recommended)"
end
