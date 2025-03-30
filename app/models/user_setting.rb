class UserSetting < ApplicationRecord
  belongs_to :user

  # Add validations here if needed
  validates :default_date_range_list_display, presence: true
  validates :default_currency, presence: true

  # Set default currency when empty
  before_validation :set_default_currency

  private

  def set_default_currency
    self.default_currency ||= "USD"
  end
end
