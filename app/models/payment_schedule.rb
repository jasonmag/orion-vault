class PaymentSchedule < ApplicationRecord
  belongs_to :list

  # Define constants for the frequency strings
  FREQUENCY_MONTHLY = "monthly"
  FREQUENCY_WEEKLY = "weekly"
  FREQUENCY_BI_WEEKLY = "bi-weekly"
  FREQUENCY_YEARLY = "yearly"
  FREQUENCY_ONCE = "once"

  # Define a frozen array of frequency constants for validation
  FREQUENCIES = [ FREQUENCY_MONTHLY, FREQUENCY_WEEKLY, FREQUENCY_BI_WEEKLY, FREQUENCY_YEARLY, FREQUENCY_ONCE ].freeze

  # Validation for frequency
  validates :frequency, presence: true, inclusion: { in: FREQUENCIES }
  validates :notification_lead_time, presence: true

  # Conditional validations
  validates :day_of_month, presence: true, if: :monthly?
  validates :day_of_week, presence: true, if: :weekly_or_biweekly?
  validates :month_of_year, presence: true, if: :yearly?

  # Methods to check the frequency type using constants
  def monthly?
    frequency == FREQUENCY_MONTHLY
  end

  def weekly?
    frequency == FREQUENCY_WEEKLY
  end

  def biweekly?
    frequency == FREQUENCY_BI_WEEKLY
  end

  def weekly_or_biweekly?
    weekly? || biweekly?
  end

  def yearly?
    frequency == FREQUENCY_YEARLY
  end

  def once?
    frequency == FREQUENCY_ONCE
  end

  # Return the human-readable version of the frequency
  def human_readable_frequency
    case frequency
    when FREQUENCY_MONTHLY
      FREQUENCY_MONTHLY.capitalize
    when FREQUENCY_WEEKLY
      FREQUENCY_WEEKLY.capitalize
    when FREQUENCY_BI_WEEKLY
      FREQUENCY_BI_WEEKLY.capitalize
    when FREQUENCY_YEARLY
      FREQUENCY_YEARLY.capitalize
    when FREQUENCY_ONCE
      FREQUENCY_ONCE.capitalize
    else
      "Unknown frequency"
    end
  end
end
