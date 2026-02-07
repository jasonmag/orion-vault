class Expense < ApplicationRecord
  SOURCE_DUE = "due"
  SOURCE_MANUAL = "manual"
  SOURCES = [ SOURCE_DUE, SOURCE_MANUAL ].freeze

  belongs_to :user
  belongs_to :list, optional: true
  belongs_to :credit_card_type, optional: true

  validates :name, presence: true
  validates :amount, presence: true
  validates :paid_at, presence: true
  validates :source, presence: true, inclusion: { in: SOURCES }
  validates :credit_card_type, presence: true, if: :card_payment?
  validate :credit_card_type_matches_user_setting

  before_validation :clear_credit_card_type_unless_card

  private

  def card_payment?
    payment_method == "card"
  end

  def clear_credit_card_type_unless_card
    self.credit_card_type = nil unless card_payment?
  end

  def credit_card_type_matches_user_setting
    return if credit_card_type.blank? || user.blank?

    user_setting_id = user.user_setting&.id
    return if user_setting_id.present? && credit_card_type.user_setting_id == user_setting_id

    errors.add(:credit_card_type, "is invalid")
  end
end
