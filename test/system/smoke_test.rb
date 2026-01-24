require "application_system_test_case"

class SmokeTest < ApplicationSystemTestCase
  setup do
    # Spina requires an account to render pages
    Spina::Account.find_or_create_by!(name: "Test Site") do |account|
      account.theme = "default"
    end

    # Create homepage if it doesn't exist
    Spina::Page.find_or_create_by!(name: "homepage") do |page|
      page.title = "Home"
      page.view_template = "homepage"
      page.deletable = false
      page.position = 1
    end
  end

  test "homepage loads successfully" do
    visit "/"
    # Just verify the page loaded without a 500 error
    assert_no_text "We're sorry, but something went wrong"
    assert page.has_css?("body")
  end
end
