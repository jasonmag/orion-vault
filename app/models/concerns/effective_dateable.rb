# app/models/concerns/effective_dateable.rb
module EffectiveDateable
  extend ActiveSupport::Concern

  included do
    # Scope to display items that meet the criteria based on effective dates
    scope :visible, -> {
      joins(:payment_schedule) # Ensure the same join is used
        .where.not(effective_start_date: nil)
        .where("effective_start_date <= ?", Date.today)
        .where("effective_end_date IS NULL OR effective_end_date >= ?", Date.today)
    }

    # To handle visibility for FREQUENCY_ONCE within a date range
    scope :with_frequency_once, ->(start_date, end_date) {
      joins(:payment_schedule)
        .where(payment_schedules: { frequency: PaymentSchedule::FREQUENCY_ONCE })
        .where("effective_start_date BETWEEN ? AND ?", start_date, end_date)
    }

    # Combine the standard visibility and frequency once queries
    scope :visible_or_once, ->(start_date, end_date) {
      visible.or(with_frequency_once(start_date, end_date))
    }
  end

  # Method to check if an individual record is visible based on the effective dates
  def visible?
    effective_start_date.present? &&
    effective_start_date <= Date.today &&
    (effective_end_date.nil? || effective_end_date >= Date.today)
  end
end
