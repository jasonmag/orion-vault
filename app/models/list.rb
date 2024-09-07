class List < ApplicationRecord
  belongs_to :user

  include OrderableByDate
  include EffectiveDateable

  # specify the column orderBy
  orderable_by_date :due_date

  # Set default effective_start_date to today if not provided
  before_validation :set_default_effective_start_date

  private

  def set_default_effective_start_date
    self.effective_start_date ||= Date.today
  end
end
