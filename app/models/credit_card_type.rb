class CreditCardType < ApplicationRecord
  belongs_to :user_setting

  before_validation :normalize_fields

  validates :bank_name, presence: true, length: { maximum: 255 }
  validates :last4, presence: true, format: { with: /\A\d{4}\z/, message: "must be 4 digits" }

  private

  def normalize_fields
    self.bank_name = bank_name.to_s.strip
    self.last4 = last4.to_s.strip
  end
end
