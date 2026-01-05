class Expense < ApplicationRecord
  SOURCE_DUE = "due"
  SOURCE_MANUAL = "manual"
  SOURCES = [ SOURCE_DUE, SOURCE_MANUAL ].freeze

  belongs_to :user
  belongs_to :list, optional: true

  validates :name, presence: true
  validates :amount, presence: true
  validates :paid_at, presence: true
  validates :source, presence: true, inclusion: { in: SOURCES }
end
