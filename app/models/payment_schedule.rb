class PaymentSchedule < ApplicationRecord
  belongs_to :list
  validates :frequency, presence: true
  validates :notification_lead_time, presence: true
end
