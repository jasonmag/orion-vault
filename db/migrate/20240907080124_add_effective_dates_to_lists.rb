class AddEffectiveDatesToLists < ActiveRecord::Migration[7.2]
  def change
    add_column :lists, :effective_start_date, :date
    add_column :lists, :effective_end_date, :date
  end
end
