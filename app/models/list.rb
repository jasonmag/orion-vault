class List < ApplicationRecord
  belongs_to :user
  has_one :payment_schedule, dependent: :destroy
  accepts_nested_attributes_for :payment_schedule

  include SoftDeletable
  include OrderableByDate
  include EffectiveDateable
  include DueDateable

  # Specify the column to order by using the next_due_date method
  orderable_by_date :next_due_date

  # Set default effective_start_date to today if not provided
  before_validation :set_default_effective_start_date

  def checked_status_for(user)
    check_list_history = CheckListHistory.find_by(
      user_id: user.id,
      list_id: self.id,
      due_date: self.next_due_date
    )
    puts check_list_history&.checked
    check_list_history&.checked # Return the checked value or nil if not found
  end

  private

  def set_default_effective_start_date
    self.effective_start_date ||= Date.today
  end
end
