# app/models/concerns/effective_dateable.rb
module EffectiveDateable
  extend ActiveSupport::Concern

  included do
    scope :within_effective_dates, -> {
      where("effective_start_date <= ? AND (effective_end_date IS NULL OR effective_end_date >= ?)", Date.today, Date.today)
    }
  end
end
