# app/models/concerns/orderable_by_date.rb
module OrderableByDate
  extend ActiveSupport::Concern

  class_methods do
    def orderable_by_date(column_name = :updated_at)
      scope :ordered_by_date, -> { order(column_name => :asc) }
      scope :ordered_by_date_desc, -> { order(column_name => :desc) }
    end
  end
end
