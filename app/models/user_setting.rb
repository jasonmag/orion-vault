class UserSetting < ApplicationRecord
  belongs_to :user

  # Add validations here if needed
  validates :default_date_range_list_display, presence: true
  validates :default_currency, presence: true
end
