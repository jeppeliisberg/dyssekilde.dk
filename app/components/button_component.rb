# frozen_string_literal: true

class ButtonComponent < ApplicationComponent
  def initialize(variant: :primary, size: :md, href: nil)
    @variant = variant
    @size = size
    @href = href
  end

  attr_reader :variant, :size, :href

  def link?
    href.present?
  end
end
