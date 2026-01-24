# frozen_string_literal: true

class FooterComponent < ApplicationComponent
  def initialize(navigation_items: [])
    @navigation_items = navigation_items
  end

  attr_reader :navigation_items
end
