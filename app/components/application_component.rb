# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  # Shared helpers for Spina navigation items

  def item_path(item)
    item.page&.materialized_path || item.url || "/"
  end

  def item_title(item)
    if item.page
      item.page.menu_title.presence || item.page.title
    else
      item.url_title.presence || "Link"
    end
  end
end
