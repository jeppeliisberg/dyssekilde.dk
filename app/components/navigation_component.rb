# frozen_string_literal: true

class NavigationComponent < ApplicationComponent
  def initialize(items: [], variant: :desktop)
    @items = items
    @variant = variant
  end

  attr_reader :items, :variant

  def desktop?
    variant == :desktop
  end

  def mobile?
    variant == :mobile
  end

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
