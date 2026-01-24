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
end
