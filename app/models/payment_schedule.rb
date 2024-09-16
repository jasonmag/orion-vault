class PaymentSchedule < ApplicationRecord
  belongs_to :list
  validates :frequency, presence: true, inclusion: { in: %w[monthly weekly bi-weekly yearly once] }
  validates :notification_lead_time, presence: true

  validates :day_of_month, presence: true, if: -> { frequency == "monthly" }
  validates :day_of_week, presence: true, if: -> { frequency == "weekly" }
  validates :month_of_year, presence: true, if: -> { frequency == "yearly" }
end
