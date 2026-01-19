# frozen_string_literal: true

class AlertComponent < ApplicationComponent
  def initialize(type: :info)
    @type = type
  end

  attr_reader :type
end
