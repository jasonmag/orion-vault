module OrderableByDate
  extend ActiveSupport::Concern

  class_methods do
    def orderable_by_date(column_name = :updated_at)
      # Check if the column name corresponds to a database column or a method
      if column_names.include?(column_name.to_s)
        # It's a database column, so use `order`
        scope :ordered_by_date, -> { order(column_name => :asc) }
        scope :ordered_by_date_desc, -> { order(column_name => :desc) }
      else
        # It's a method, so sort using Ruby's `sort_by`
        scope :ordered_by_date, -> {
          all.sort_by { |record| record.send(column_name) || Date.new(9999, 12, 31) }
        }
        scope :ordered_by_date_desc, -> {
          all.sort_by { |record| record.send(column_name) || Date.new(0) }.reverse
        }
      end
    end
  end
end
