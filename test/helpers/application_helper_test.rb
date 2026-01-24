require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  # Mock page object for testing
  class MockPage
    attr_accessor :seo_title, :description, :title, :contents

    def initialize(attrs = {})
      @seo_title = attrs[:seo_title]
      @description = attrs[:description]
      @title = attrs[:title] || "Default Page"
      @contents = attrs[:contents] || {}
      @parts = attrs[:parts] || {}
    end

    def content(part_name)
      @contents[part_name]
    end

    def find_part(part_name)
      @parts[part_name]
    end
  end

  # Mock account object for testing
  class MockAccount
    attr_accessor :name

    def initialize(name = "Test Site")
      @name = name
    end
  end

  setup do
    @mock_page = MockPage.new(title: "Test Page")
    @mock_account = MockAccount.new("Dyssekilde")
  end

  # Override Spina helpers with our mocks
  def current_page
    @mock_page
  end

  def current_spina_account
    @mock_account
  end

  # meta_title tests

  test "meta_title returns seo_title when present" do
    @mock_page.seo_title = "Custom SEO Title"

    assert_equal "Custom SEO Title", meta_title
  end

  test "meta_title falls back to page title with site name when no seo_title" do
    @mock_page.seo_title = nil
    @mock_page.title = "About Us"

    assert_equal "About Us | Dyssekilde", meta_title
  end

  test "meta_title falls back when seo_title is empty string" do
    @mock_page.seo_title = ""
    @mock_page.title = "Contact"

    assert_equal "Contact | Dyssekilde", meta_title
  end

  # meta_description tests

  test "meta_description returns description when present" do
    @mock_page.description = "This is a custom meta description for SEO purposes."

    assert_equal "This is a custom meta description for SEO purposes.", meta_description
  end

  test "meta_description extracts and truncates text content when no description" do
    long_text = "This is a very long piece of text content that should be truncated to fit within the meta description character limit. " \
                "It contains more than one hundred sixty characters to ensure proper truncation behavior is tested."
    @mock_page.description = nil
    @mock_page.contents = { text: long_text }

    result = meta_description

    assert result.length <= 162
    assert result.end_with?("...")
  end

  test "meta_description returns nil when no content available" do
    @mock_page.description = nil
    @mock_page.contents = {}

    assert_nil meta_description
  end

  test "meta_description falls back to house_description when text is not present" do
    @mock_page.description = nil
    @mock_page.contents = { text: nil, house_description: "A cozy house in Dyssekilde." }

    assert_equal "A cozy house in Dyssekilde.", meta_description
  end

  test "meta_description strips HTML tags from content" do
    @mock_page.description = nil
    @mock_page.contents = { text: "<p>This is <strong>bold</strong> and <em>italic</em> text.</p>" }

    result = meta_description

    assert_not_includes result, "<p>"
    assert_not_includes result, "<strong>"
    assert_not_includes result, "</p>"
    assert_includes result, "This is bold and italic text."
  end

  test "meta_description returns nil when content is blank string" do
    @mock_page.description = nil
    @mock_page.contents = { text: "   " }

    assert_nil meta_description
  end

  test "meta_description truncates at word boundary" do
    # Create text that's over 162 chars with a word boundary near the limit
    text = "Word " * 40  # 200 chars
    @mock_page.description = nil
    @mock_page.contents = { text: text }

    result = meta_description

    # Should end with ... and not cut in middle of a word
    assert result.end_with?("...")
    # The text before ... should end with a complete word
    without_ellipsis = result.chomp("...")
    assert without_ellipsis.end_with?("Word")
  end
end
