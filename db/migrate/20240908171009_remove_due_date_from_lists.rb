class RemoveDueDateFromLists < ActiveRecord::Migration[7.2]
  def change
    remove_column :lists, :due_date, :date
  end
end
