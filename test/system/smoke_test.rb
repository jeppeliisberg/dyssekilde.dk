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

  test "houses collection page loads successfully" do
    # Create houses resource
    resource = Spina::Resource.find_or_create_by!(name: "houses") do |r|
      r.label = "Rental Houses"
    end

    # Create houses collection page
    houses_page = Spina::Page.find_or_create_by!(name: "houses") do |page|
      page.title = "Boliger"
      page.view_template = "houses"
      page.deletable = true
      page.position = 2
    end

    # Create a sample house
    house = Spina::Page.find_or_create_by!(name: "test-house") do |page|
      page.title = "Testvej 123"
      page.view_template = "house"
      page.resource = resource
      page.deletable = true
      page.position = 1
    end

    visit houses_page.materialized_path
    assert_no_text "We're sorry, but something went wrong"
    assert page.has_css?("body")
    assert page.has_text?("Boliger")
  end

  test "individual house page loads successfully" do
    # Create houses resource
    resource = Spina::Resource.find_or_create_by!(name: "houses") do |r|
      r.label = "Rental Houses"
    end

    # Create a sample house
    house = Spina::Page.find_or_create_by!(name: "test-house-detail") do |page|
      page.title = "Elmegade 42"
      page.view_template = "house"
      page.resource = resource
      page.deletable = true
      page.position = 1
    end

    visit house.materialized_path
    assert_no_text "We're sorry, but something went wrong"
    assert page.has_css?("body")
    assert page.has_text?("Elmegade 42")
  end
end
