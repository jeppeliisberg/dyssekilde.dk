# frozen_string_literal: true

Spina.define_template "gallery" do
  part "text", :text, title: "Body", hint: "Your main content"
  part "gallery_images", :image_collection, title: "Gallery Images", hint: "Images for the gallery grid"
end
