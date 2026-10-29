require "test_helper"

class SpinaThemeTest < ActiveSupport::TestCase
  setup do
    @theme = Spina::Theme.find_by_name("default")
  end

  test "parts are defined in page template files, not the legacy initializer config" do
    assert @theme.uses_page_templates?
    assert_empty @theme.parts
  end

  test "view templates keep their titles and part lists" do
    expected = {
      "homepage" => [ "Homepage", %w[hero_image subtitle text] ],
      "show" => [ "Page", %w[hero_image text] ],
      "gallery" => [ "Gallery", %w[text gallery_images] ],
      "house" => [ "House", %w[house_name house_description house_images house_bedrooms house_bathrooms house_max_guests house_sqm house_pricing house_contact] ],
      "houses" => [ "Houses Collection", %w[text og_image] ]
    }

    actual = @theme.view_templates.to_h { |template| [ template[:name], [ template[:title], template[:parts] ] ] }

    assert_equal expected, actual
  end

  test "part definitions keep their titles, hints and types" do
    text = @theme.page_template_definitions("homepage").find { |part| part[:name] == "text" }

    assert_equal({ name: "text", title: "Body", hint: "Your main content", part_type: "Spina::Parts::Text" }, text)
  end
end
