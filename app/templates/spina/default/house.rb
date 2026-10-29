# frozen_string_literal: true

Spina.define_template "house" do
  part "house_name", :line, title: "House Name", hint: "Friendly name like 'Cozy Cottage'"
  part "house_description", :text, title: "Description"
  part "house_images", :image_collection, title: "Photos"
  part "house_bedrooms", :line, title: "Bedrooms"
  part "house_bathrooms", :line, title: "Bathrooms"
  part "house_max_guests", :line, title: "Max Guests"
  part "house_sqm", :line, title: "Square Meters"
  part "house_pricing", :line, title: "Pricing"
  part "house_contact", :multi_line, title: "Contact"
end
