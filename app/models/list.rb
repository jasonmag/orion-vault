class List < ApplicationRecord
  belongs_to :user

  include OrderableByDate

  # specify the column orderBy
  orderable_by_date :due_date
end
