class CheckListHistory < ApplicationRecord
  belongs_to :user
  belongs_to :list
  validates :due_date, presence: true
end
