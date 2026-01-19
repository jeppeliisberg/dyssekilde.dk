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
    current_path = helpers.request.fullpath
    # Extract the path without locale prefix
    path_without_locale = current_path.sub(%r{^/(da|en)}, "")
    path_without_locale = "/" if path_without_locale.blank?

    # Default locale (da) uses root path, others get prefix
    if locale == I18n.default_locale
      path_without_locale
    else
      "/#{locale}#{path_without_locale == '/' ? '' : path_without_locale}"
    end
  end
end
