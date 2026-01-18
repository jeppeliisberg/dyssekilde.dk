require "application_system_test_case"

class SmokeTest < ApplicationSystemTestCase
  setup do
    # Spina requires an account to render pages
    Spina::Account.find_or_create_by!(name: "Test Site") do |account|
      account.theme = "default"
    end
  end

  test "homepage loads successfully" do
    visit "/"
    # Just verify the page loaded without a 500 error
    assert_no_text "We're sorry, but something went wrong"
    assert page.has_css?("body")
  end
end
