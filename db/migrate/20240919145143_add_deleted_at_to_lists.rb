class AddDeletedAtToLists < ActiveRecord::Migration[7.2]
  def change
    add_column :lists, :deleted_at, :datetime
  end
end