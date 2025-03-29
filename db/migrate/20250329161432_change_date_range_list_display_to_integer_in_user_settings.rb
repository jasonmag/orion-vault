class ChangeDateRangeListDisplayToIntegerInUserSettings < ActiveRecord::Migration[8.0]
  def change
    remove_column :user_settings, :date_range_list_display, :string
    add_column :user_settings, :date_range_list_display, :integer
  end
end
