# app/models/concerns/effective_dateable.rb
module EffectiveDateable
  extend ActiveSupport::Concern

  included do
    scope :within_effective_dates, -> {
      where("effective_start_date <= ? AND (effective_end_date IS NULL OR effective_end_date >= ?)", Date.today, Date.today)
    }

    # Scope to display items that meet the criteria based on effective dates
    scope :visible, -> {
      where.not(effective_start_date: nil) # effective_start_date must be present
      .where("effective_start_date <= ?", Date.today) # Start date is before or equal to today
      .where("effective_end_date IS NULL OR effective_end_date >= ?", Date.today) # End date is either null or after today
      .where("effective_start_date <= ? AND (effective_end_date IS NULL OR effective_end_date >= ?)", Date.today, Date.today) # Current date between start and end dates
    }
  end

  # Method to check if an individual record is visible based on the effective dates
  def visible?
    effective_start_date.present? &&
    effective_start_date <= Date.today &&
    (effective_end_date.nil? || effective_end_date >= Date.today)
  end
end
