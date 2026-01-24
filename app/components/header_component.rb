# frozen_string_literal: true

class HeaderComponent < ApplicationComponent
  def initialize(navigation_items: [])
    @navigation_items = navigation_items
  end

  attr_reader :navigation_items

  def available_locales
    I18n.available_locales
  end

  def current_locale
    I18n.locale
  end

  def locale_switch_path(locale)
    # Try to get the translated path from Spina
    if (page = helpers.current_page rescue nil)
      I18n.with_locale(locale) do
        return Spina::Page.find(page.id).materialized_path
      end
    end

    # Fallback for non-Spina pages: simple locale prefix swap
    current_path = helpers.request.fullpath
    path_without_locale = current_path.sub(%r{^/(da|en)}, "")
    path_without_locale = "/" if path_without_locale.blank?

    if locale == I18n.default_locale
      path_without_locale
    else
      "/#{locale}#{path_without_locale == '/' ? '' : path_without_locale}"
    end
  end
end
